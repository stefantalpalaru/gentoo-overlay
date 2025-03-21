# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs toolchain-funcs unpacker

DRIVER_PV="560.35.03"

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="https://developer.nvidia.com/cuda-zone"
SRC_URI="https://developer.download.nvidia.com/compute/cuda/${PV}/local_installers/cuda_${PV}_${DRIVER_PV}_linux.run"
S="${WORKDIR}"

LICENSE="NVIDIA-CUDA"
SLOT="0/${PV}"
KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE="debugger examples nsight profiler rdma vis-profiler sanitizer"
RESTRICT="bindist mirror"

# since CUDA 11, the bundled toolkit driver (== ${DRIVER_PV}) and the
# actual required minimum driver version are different.
RDEPEND="
	<sys-devel/gcc-14_pre[cxx]
	virtual/libcrypt
	examples? (
		media-libs/freeglut
		media-libs/glu
	)
	nsight? (
		app-crypt/mit-krb5
		dev-libs/libpfm
		dev-libs/wayland
		dev-qt/qtwayland:6
		>=dev-libs/openssl-3
		media-libs/tiff-compat:4
		sys-libs/zlib
	)
	rdma? ( sys-cluster/rdma-core )
	vis-profiler? (
		>=virtual/jre-1.8:*
	)"
BDEPEND="nsight? ( dev-util/patchelf )"

QA_PREBUILT="opt/cuda/*"
CHECKREQS_DISK_BUILD="15000M"

PATCHES=(
	"${FILESDIR}"/nvidia-cuda-toolkit-12.6.1-glibc-2.41.patch
)

pkg_setup() {
	check-reqs_pkg_setup
}

src_prepare() {
	# ATTENTION: change requires revbump, see link below for supported GCC # versions
	# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#system-requirements
	local cuda_supported_gcc="8.5 9.5 10 11 12 13"

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
		"${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die

	default
}

src_install() {
	local cudadir=/opt/cuda
	local ecudadir="${EPREFIX}${cudadir}"
	local pathextradirs ldpathextradirs
	dodir ${cudadir}
	into ${cudadir}

	# Install standard sub packages
	local builddirs=(
		builds/cuda_{cccl,cudart,cuobjdump,cuxxfilt,demo_suite,nvcc,nvdisasm,nvml_dev,nvprune,nvrtc,nvtx,opencl}
		builds/lib{cublas,cufft,cufile,curand,cusolver,cusparse,npp,nvjitlink,nvjpeg}
		builds/nvidia_fs
		$(usex profiler "builds/cuda_nvprof builds/cuda_cupti builds/cuda_profiler_api" "")
		$(usex vis-profiler "builds/cuda_nvvp" "")
		$(usex debugger "builds/cuda_gdb" "")
	)

	local d f
	for d in "${builddirs[@]}"; do
		ebegin "Installing ${d}"
		[[ -d ${d} ]] || die "Directory does not exist: ${d}"

		if [[ -d ${d}/bin ]]; then
			for f in ${d}/bin/*; do
				if [[ -f ${f} ]]; then
					dobin "${f}"
				else
					insinto ${cudadir}/bin
					doins -r "${f}"
				fi
			done
		fi

		insinto ${cudadir}
		if [[ -d ${d}/targets ]]; then
			doins -r "${d}"/targets
		fi
		if [[ -d ${d}/share ]]; then
			doins -r "${d}"/share
		fi
		if [[ -d ${d}/extras ]]; then
			doins -r "${d}"/extras
		fi
		eend $?
	done
	dobin "${T}"/cuda-config

	doins builds/EULA.txt
	# nvml and nvvm need special handling
	ebegin "Installing nvvm"
	doins -r builds/cuda_nvcc/nvvm
	fperms +x ${cudadir}/nvvm/bin/cicc
	eend $?

	ebegin "Installing nvml"
	doins -r builds/cuda_nvml_dev/nvml
	eend $?

	if use sanitizer; then
		ebegin "Installing sanitizer"
		dobin builds/integration/Sanitizer/compute-sanitizer
		doins -r builds/cuda_sanitizer_api/compute-sanitizer
		# special handling for the executable
		fperms +x ${cudadir}/compute-sanitizer/compute-sanitizer
		eend $?
	fi

	use debugger && ldpathextradirs+=":${ecudadir}/extras/Debugger/lib64"
	use profiler && ldpathextradirs+=":${ecudadir}/extras/CUPTI/lib64"

	if use vis-profiler; then
		ebegin "Installing libnvvp"
		doins -r builds/cuda_nvvp/libnvvp
		# special handling for the executable
		fperms +x ${cudadir}/libnvvp/nvvp
		eend $?
		pathextradirs+=":${ecudadir}/libnvvp"
	fi

	if use nsight; then
		local ncu_dir=$(grep -o 'nsight-compute-[0-9][0-9\.]*' -m1 manifests/cuda_x86_64.xml)
		ebegin "Installing ${ncu_dir}"
		mv builds/nsight_compute builds/${ncu_dir} || die
		doins -r builds/${ncu_dir}

		# check this list on every bump
		local exes=(
			${ncu_dir}/ncu
			${ncu_dir}/ncu-ui
			${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/libexec/QtWebEngineProcess
			${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/CrashReporter
			${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/OpenGLVersionChecker
			${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/QdstrmImporter
			${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/ncu-ui
			${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/ncu-ui.bin
			${ncu_dir}/target/linux-desktop-glibc_2_11_3-x64/TreeLauncherSubreaper
			${ncu_dir}/target/linux-desktop-glibc_2_11_3-x64/TreeLauncherTargetLdPreloadHelper
			${ncu_dir}/target/linux-desktop-glibc_2_11_3-x64/ncu
		)

		dobin builds/integration/nsight-compute/{ncu,ncu-ui}
		eend $?

		# remove rdma libs (unless USE=rdma)
		if ! use rdma; then
			rm -r "${ED}"/${cudadir}/${ncu_dir}/host/target-linux-x64/CollectX || die
		fi

		local nsys_dir=$(grep -o 'nsight-systems-[0-9][0-9\.]*' -m1 manifests/cuda_x86_64.xml)
		ebegin "Installing ${nsys_dir}"
		mv builds/nsight_systems builds/${nsys_dir} || die
		doins -r builds/${nsys_dir}

		# check this list on every bump
		exes+=(
			${nsys_dir}/host-linux-x64/nsys-ui
			${nsys_dir}/host-linux-x64/nsys-ui.bin
			${nsys_dir}/host-linux-x64/ResolveSymbols
			${nsys_dir}/host-linux-x64/ImportNvtxt
			${nsys_dir}/host-linux-x64/CrashReporter
			${nsys_dir}/host-linux-x64/QdstrmImporter
			${nsys_dir}/host-linux-x64/libexec/QtWebEngineProcess
			${nsys_dir}/target-linux-x64/nsys
			${nsys_dir}/target-linux-x64/launcher
			${nsys_dir}/target-linux-x64/nvgpucs
			${nsys_dir}/target-linux-x64/nsys-launcher
			${nsys_dir}/target-linux-x64/sqlite3
			${nsys_dir}/target-linux-x64/python/bin/python
			${nsys_dir}/target-linux-x64/CudaGpuInfoDumper
		)

		# remove rdma libs (unless USE=rdma)
		if ! use rdma; then
			rm -r "${ED}"/${cudadir}/${nsys_dir}/target-linux-x64/CollectX || die
		fi

		dobin builds/integration/nsight-systems/{nsight-sys,nsys,nsys-ui}
		eend $?

		# nsight scripts and binaries need to have their executable bit set, #691284
		for f in "${exes[@]}"; do
			fperms +x ${cudadir}/${f}
		done

		# fix broken RPATHs
		patchelf --set-rpath '$ORIGIN' \
		"${ED}"/${cudadir}/${ncu_dir}/host/{linux-desktop-glibc_2_11_3-x64,target-linux-x64}/{libarrow.so,libparquet.so.500.0.0} || die
		patchelf --set-rpath '$ORIGIN' \
		"${ED}"/${cudadir}/${nsys_dir}/{host-linux-x64,target-linux-x64}/{libarrow.so,libparquet.so.500.0.0} || die

		# remove foreign archs (triggers SONAME warning, #749903)
		rm -r "${ED}"/${cudadir}/${ncu_dir}/target/linux-desktop-t210-a64 || die

		# unbundle libstdc++
		rm "${ED}"/${cudadir}/${nsys_dir}/host-linux-x64/libstdc++.so.6 || die

		# unbundle openssl
		rm "${ED}"/${cudadir}/${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/lib{crypto,ssl}.so* || die
		rm "${ED}"/${cudadir}/${nsys_dir}/host-linux-x64/lib{crypto,ssl}.so* || die

		# unbundle libpfm
		rm "${ED}"/${cudadir}/${nsys_dir}/host-linux-x64/libpfm.so* || die

		# TODO: unbundle qt5
		# TODO: unbundle boost
		# TODO: unbundle icu
		# TODO: unbundle mesa
		# TODO: unbundle libSshClient
		# TODO: unbundle sqlite
	fi

	if use examples; then
		local exes=(
			extras/demo_suite/bandwidthTest
			extras/demo_suite/busGrind
			extras/demo_suite/deviceQuery
			extras/demo_suite/nbody
			extras/demo_suite/oceanFFT
			extras/demo_suite/randomFog
			extras/demo_suite/vectorAdd
		)

		# set executable bit on demo_suite binaries
		for f in "${exes[@]}"; do
			fperms +x ${cudadir}/${f}
		done
	else
		rm -r "${ED}"/${cudadir}/extras/demo_suite || die
	fi

	# remove rdma libs (unless USE=rdma)
	if ! use rdma; then
		rm "${ED}"/${cudadir}/targets/x86_64-linux/lib/libcufile_rdma* || die
	fi

	# Add include and lib symlinks
	dosym targets/x86_64-linux/include ${cudadir}/include
	dosym targets/x86_64-linux/lib ${cudadir}/lib64

	# Remove bad symlinks
	rm "${ED}"/${cudadir}/targets/x86_64-linux/include/include || die
	rm "${ED}"/${cudadir}/targets/x86_64-linux/lib/lib64 || die

	# Remove dead gdb plugins
	if use debugger; then
		rm "${ED}"/${cudadir}/bin/cuda-gdb-python3.{8,9}-tui || die
	fi

	newenvd - 99cuda <<-EOF
		PATH=${ecudadir}/bin${pathextradirs}
		ROOTPATH=${ecudadir}/bin
		LDPATH=${ecudadir}/lib64:${ecudadir}/nvvm/lib64${ldpathextradirs}
	EOF

	# Cuda prepackages libraries, don't revdep-build on them
	insinto /etc/revdep-rebuild
	newins - 80${PN} <<-EOF
		SEARCH_DIRS_MASK="${ecudadir}"
	EOF

	# https://bugs.gentoo.org/926116
	insinto /etc/sandbox.d
	newins - 80${PN} <<-EOF
		SANDBOX_PREDICT="/proc/self/task"
	EOF
}

pkg_postinst_check() {
	local a="$("${EROOT}"/opt/cuda/bin/cuda-config -s)"
	local b="0.0"
	local v
	for v in ${a}; do
		ver_test "${v}" -gt "${b}" && b="${v}"
	done

	# if gcc and if not gcc-version is at least greatest supported
	if tc-is-gcc && \
		ver_test $(gcc-version) -gt "${b}"; then
			ewarn
			ewarn "gcc > ${b} will not work with CUDA"
			ewarn "Make sure you set an earlier version of gcc with gcc-config"
			ewarn "or append --compiler-bindir= pointing to a gcc bindir like"
			ewarn "--compiler-bindir=${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc${b}"
			ewarn "to the nvcc compiler flags"
			ewarn
	fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_postinst_check
	fi

	if use profiler || use nsight; then
		einfo
		einfo "nvidia-drivers restrict access to performance counters."
		einfo "You'll need to either run profiling tools (nvprof, nsight) "
		einfo "using sudo (needs cap SYS_ADMIN) or add the following line to "
		einfo "a modprobe configuration file "
		einfo "(e.g. /etc/modprobe.d/nvidia-prof.conf): "
		einfo
		einfo "options nvidia NVreg_RestrictProfilingToAdminUsers=0"
		einfo
	fi
}
