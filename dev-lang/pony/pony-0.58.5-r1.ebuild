# Copyright 2014-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_COMPAT=( 17 18 )
CMAKE_IN_SOURCE_BUILD=1

inherit cmake git-r3 llvm-r1

DESCRIPTION="Compiler for the Pony language"
HOMEPAGE="http://www.ponylang.org/"
EGIT_REPO_URI="https://github.com/ponylang/ponyc"
EGIT_COMMIT="${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lto test vim-syntax"
RESTRICT="strip
	network-sandbox
	!test? ( test )"

RDEPEND="
	sys-libs/zlib
	vim-syntax? ( app-vim/pony-syntax )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/clang
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/pony-0.58.5-lld.patch"
)

pkg_setup() {
	llvm-r1_pkg_setup
}

src_prepare() {
	default

	sed -i \
		-e 's/-Werror//' \
		CMakeLists.txt || die

	sed -i \
		-e "s/-DCMAKE_C_FLAGS=\"-march=\$(arch) -mtune=\$(tune)\"/-DCMAKE_C_FLAGS=\"${CFLAGS}\"/g" \
		-e "s/-DCMAKE_CXX_FLAGS=\"-march=\$(arch) -mtune=\$(tune)\"/-DCMAKE_CXX_FLAGS=\"${CXXFLAGS}\"/g" \
		-e 's/ln -s/ln -sr/g' \
		Makefile || die

	gcc_lib_dir="$(gcc-config -L | cut -d ':' -f 1)"
	sed -i \
		-e "s#/lib/x86_64-linux-gnu#${gcc_lib_dir}#" \
		src/libponyc/codegen/genexe.c || die
}

common_make_args="config=release verbose=yes"

src_configure() {
	emake ${common_make_args} build_flags="${MAKEOPTS}" libs

	local extra_args=""
	if use lto; then
		extra_args="${extra_args} lto=yes"
	fi
	emake ${common_make_args} ${extra_args} build_flags="${MAKEOPTS}" configure
}

src_compile() {
	emake ${common_make_args} build_flags="${MAKEOPTS}" build
}

src_test() {
	emake ${common_make_args} build_flags="${MAKEOPTS}" test
}

src_install() {
	emake ${common_make_args} build_flags="${MAKEOPTS}" prefix="${ED}/usr" install
}
