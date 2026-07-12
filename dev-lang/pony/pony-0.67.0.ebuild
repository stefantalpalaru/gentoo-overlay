# Copyright 2014-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_COMPAT=( 17 18 19 20 21 22 )
CMAKE_IN_SOURCE_BUILD=1

inherit cmake git-r3 llvm-r2 multiprocessing

DESCRIPTION="Compiler for the Pony language"
HOMEPAGE="http://www.ponylang.org/"
EGIT_REPO_URI="https://github.com/ponylang/ponyc"
EGIT_COMMIT="${PV}"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+lto test vim-syntax"
RESTRICT="strip
	network-sandbox
	!test? ( test )"

COMMON_DEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/lld:${LLVM_SLOT}=
	')
"
RDEPEND="
	${COMMON_DEPEND}
	sys-libs/zlib
	vim-syntax? ( app-vim/pony-syntax )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/pony-0.67.0-flags.patch
)

pkg_setup() {
	llvm-r2_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's/-Werror//' \
		CMakeLists.txt || die

	export VERBOSE=1

	cmake_src_prepare
}

src_configure() {
	:
}

src_compile() {
	# Build libs (mainly the vendored LLVM).
	cmake \
		-DJOBS=$(makeopts_jobs) \
		-P lib/build-libs.cmake \
		|| die

	# Configure ponyc.
	cmake \
		--preset x86-64-release \
		-DPONY_USE_LTO=$(usex lto) \
		|| die

	# Build ponyc.
	cmake \
		--build \
		--preset x86-64-release \
		-DJOBS=$(makeopts_jobs) \
		|| die
}

src_test() {
	ctest \
		--preset x86-64-release \
		-L ci-core \
		-DJOBS=$(makeopts_jobs) \
		|| die
}

src_install() {
	cmake \
		--install build/build_x86-64-release \
		--prefix "${ED}/usr" \
		|| die

	# CMake creates absolute symbolic links. We want relative ones.
	for path in "${ED}"/usr/bin/*; do
		fname="$(basename ${path})"
		rm "${path}"
		ln -sr "${ED}/usr/lib/pony/"*"/bin/${fname}" "${path}"
	done

	for path in "${ED}"/usr/lib/*.a; do
		fname="$(basename ${path})"
		rm "${path}"
		ln -sr "${ED}/usr/lib/pony/"*"/lib/x86-64/${fname}" "${path}"
	done
}
