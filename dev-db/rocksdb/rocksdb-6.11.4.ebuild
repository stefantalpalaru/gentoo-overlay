# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="A Persistent Key-Value Store for Flash and RAM Storage"
HOMEPAGE="http://rocksdb.org/"
SRC_URI="https://github.com/facebook/rocksdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 Apache-2.0 ) BSD"
SLOT="0/5"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs minimal bzip2 debug gflags lz4 snappy tbb tools zlib zstd kernel_linux"

RDEPEND="bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	gflags? ( dev-cpp/gflags[${MULTILIB_USEDEP}] )
	lz4? ( app-arch/lz4[${MULTILIB_USEDEP}] )
	snappy? ( app-arch/snappy[${MULTILIB_USEDEP}] )
	tbb? ( dev-cpp/tbb[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	!static-libs? (
		dev-lang/perl:*
		sys-apps/sed
	)"

DOCS=( AUTHORS CONTRIBUTING.md DEFAULT_OPTIONS_HISTORY.md DUMP_FORMAT.md HISTORY.md LANGUAGE-BINDINGS.md README.md ROCKSDB_LITE.md USERS.md )

multilib_src_configure() {
	# Turning off "portable" would only add march=native to CXXFLAGS
	# Jemalloc currently fails to build
	# Librados is currently not available in portage
	# Tools don't seem to be installed
	# Tests don't build in the release configuration
	local mycmakeargs=(
		-DFAIL_ON_WARNINGS=OFF
		-DFORCE_SSE42=OFF
		-DPORTABLE=ON
		-DROCKSDB_LITE=$(usex minimal)
		-DWITH_ASAN=OFF
		-DWITH_BZ2=$(usex bzip2)
		-DWITH_FALLOCATE=$(usex kernel_linux)
		-DWITH_GFLAGS=$(usex gflags)
		-DWITH_JEMALLOC=OFF
		-DWITH_JNI=OFF
		-DWITH_LIBRADOS=OFF
		-DWITH_LZ4=$(usex lz4)
		-DWITH_SNAPPY=$(usex snappy)
		-DWITH_TBB=$(usex tbb)
		-DWITH_TESTS=OFF
		-DWITH_TOOLS=$(usex tools)
		-DWITH_TSAN=OFF
		-DWITH_UBSAN=OFF
		-DWITH_ZLIB=$(usex zlib)
		-DWITH_ZSTD=$(usex zstd)
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	local targets=''
	if ! use debug; then
		use static-libs && targets+='rocksdb '
		targets+='rocksdb-shared '
	else
		targets='all '
	fi
	if use tools; then
		targets+='ldb sst_dump'
	fi
	cmake-utils_src_compile $targets
}

multilib_src_install() {
	if ! use debug && ! use static-libs ; then
		sed -e '/librocksdb.a/d' -i cmake_install.cmake || die "unable to patch cmake_install.cmake to disable rocksdb.a"
	fi

	# HACK: use install/fast instead of install target
	_cmake_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install/fast || die "died running ${CMAKE_MAKEFILE_GENERATOR} install/fast"
	popd > /dev/null || die
	pushd "${S}" > /dev/null || die
	einstalldocs
	popd > /dev/null || die

	if ! use static-libs; then
		rm -f "${ED}usr/$(get_libdir)/librocksdb.a"
		for i in '' '-gentoo'; do
			sh "${FILESDIR}/filter_static_lib.sh" "${ED}usr/$(get_libdir)/cmake/rocksdb/RocksDBTargets${i}.cmake" || die
		done
	fi
	if use tools; then
		pushd "${BUILD_DIR}" > /dev/null || die
		dobin tools/ldb tools/sst_dump
		popd > /dev/null || die
	fi
}
