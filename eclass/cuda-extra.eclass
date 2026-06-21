# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cuda-extra.eclass
# @MAINTAINER:
# Ștefan Talpalaru <stefantalpalaru@yahoo.com>
# @AUTHOR:
# Ștefan Talpalaru <stefantalpalaru@yahoo.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Extra functions for CUDA packages
# @DESCRIPTION:
# This eclass contains extra functions to be used with CUDA packages.
# @EXAMPLE:
# inherit cuda-extra
# # Before running something requiring access to Nvidia dev nodes:
# cuda_check_permissions || die "Cannot access CUDA device. Aborting."

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_CUDA_EXTRA_ECLASS} ]]; then
_CUDA_EXTRA_ECLASS=1

inherit toolchain-funcs

# @FUNCTION: cuda_check_permissions
# @DESCRIPTION:
# Check if we can write to Nvidia device nodes, after bypassing the sandbox.
cuda_check_permissions() {
	if ! SANDBOX_WRITE=/dev/nvidiactl test -w /dev/nvidiactl; then
		eerror
		eerror "Cannot access the GPU at \"/dev/nvidiactl\", after bypassing the sandbox."
		if ! groups | grep -wq video; then
			eerror "User \"$(id -nu)\" is not in the \"video\" group."
			eerror "Add it with \"usermod -a -G video $(id -nu)\"."
		fi
		eerror
		return 1
	fi
}

# @FUNCTION: cuda_get_host_native_arch
# @DESCRIPTION:
# Get the host's CUDA architecture number (E.g.: "86"). Overridden by the
# "CUDAARCHS" environment variable, which can look like this: "75;86;89".
cuda_get_host_native_arch() {
	if [[ -n ${CUDAARCHS} ]]; then
		echo "${CUDAARCHS}"
		return
	fi

	cuda_add_sandbox -w
	cuda_check_permissions || die "Cannot access CUDA device. Aborting. You can set \"CUDAARCHS\" in /etc/portage/make.conf to avoid having to query the host device."
	__nvcc_device_query || eerror "failed to query the native device"
}

# @FUNCTION: cuda_gcc
# @USAGE: [-f]
# @RETURN: gcc bindir compatible with current cuda, optionally (-f) prefixed with "--compiler-bindir "
# @DESCRIPTION:
# Helper for determination of the latest gcc bindir supported by
# then current nvidia cuda toolkit.
#
# Example:
# @CODE
# cuda_gcc -f
# -> --compiler-bindir "/usr/x86_64-pc-linux-gnu/gcc-bin/4.6.3"
# @CODE
cuda_gcc() {
	debug-print-function ${FUNCNAME} "$@"

	local gcc_bin ver vers="" flag

	# Currently we only support the gnu compiler suite
	if ! tc-is-gcc ; then
		ewarn "Currently we only support the gnu compiler suite"
		return 2
	fi

	while [[ "$1" ]]; do
		case $1 in
			-f)
				flag="--compiler-bindir "
				;;
			*)
				;;
		esac
		shift
	done

	if ! vers="$(cuda-config -s)"; then
		eerror "Could not execute cuda-config"
		eerror "Make sure >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 is installed"
		die "cuda-config not found"
	fi
	if [[ -z ${vers} ]]; then
		die "Could not determine supported gcc versions from cuda-config"
	fi

	# Try the current gcc version first
	ver=$(gcc-major-version)
	if [[ -n "${ver}" ]] && [[ ${vers} =~ ${ver} ]]; then
		gcc_bin="gcc-${ver}"
	fi

	if [[ -z ${gcc_bin} ]]; then
		ver=$(best_version "sys-devel/gcc")
		ver=$(ver_cut 1-2 "${ver##*sys-devel/gcc-}")

		if [[ -n "${ver}" ]] && [[ ${vers} =~ ${ver} ]]; then
			gcc_bin="gcc-${ver}"
		fi
	fi

	for ver in ${vers}; do
		if has_version "=sys-devel/gcc-${ver}*"; then
			gcc_bin="gcc-${ver}"
		fi
	done

	if [[ -n ${gcc_bin} ]]; then
		if [[ -n ${flag} ]]; then
			echo "${flag}${gcc_bin%/}"
		else
			echo "${gcc_bin%/}"
		fi
		return 0
	else
		eerror "Only gcc version(s) ${vers} are supported,"
		eerror "of which none is installed"
		die "Only gcc version(s) ${vers} are supported"
		return 1
	fi
}

# @FUNCTION: cuda_sanitize_extra
# @DESCRIPTION:
# Correct NVCCFLAGS by adding the necessary reference to gcc bindir and
# passing CXXFLAGS to underlying compiler without disturbing nvcc.
cuda_sanitize_extra() {
	debug-print-function ${FUNCNAME} "$@"

	local rawldflags=$(raw-ldflags)
	# Be verbose if wanted
	[[ "${CUDA_VERBOSE}" == true ]] && NVCCFLAGS+=" -v"

	# Tell nvcc where to find a compatible compiler
	NVCCFLAGS+=" $(cuda_gcc -f)"

	# Tell nvcc which flags should be used for underlying C compiler
	NVCCFLAGS+=" --compiler-options \"${CXXFLAGS}\" --linker-options \"${rawldflags// /,}\""

	debug-print "Using ${NVCCFLAGS} for cuda"
	export NVCCFLAGS
}

# @FUNCTION: cuda_src_prepare_extra
# @DESCRIPTION:
# Sanitise and export NVCCFLAGS by default
cuda_src_prepare_extra() {
	debug-print-function ${FUNCNAME} "$@"

	cuda_sanitize_extra
}

fi
