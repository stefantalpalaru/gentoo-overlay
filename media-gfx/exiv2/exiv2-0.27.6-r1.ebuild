# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..13} )

inherit cmake-multilib python-any-r1

DESCRIPTION="EXIF, IPTC and XMP metadata C++ library and command line utility"
HOMEPAGE="https://exiv2.org/"
SRC_URI="https://github.com/${PN^}/${PN}/releases/download/v${PV}/${P}-Source.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P}-Source"
LICENSE="GPL-2"
# In 0.27.5, ABI seemed to be broken for bmff functions
SLOT="0/27.5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="+bmff doc examples nls +png test webready +xmp"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	png? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	webready? (
		>net-libs/libssh-0.9.1[sftp,${MULTILIB_USEDEP}]
		net-misc/curl[${MULTILIB_USEDEP}]
	)
	xmp? ( dev-libs/expat[${MULTILIB_USEDEP}] )
"
DEPEND="${DEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="
	doc? (
		${PYTHON_DEPS}
		app-text/doxygen
		dev-libs/libxslt
		media-gfx/graphviz
		virtual/pkgconfig
	)
	nls? ( sys-devel/gettext )
"

DOCS=( README.md doc/ChangeLog doc/cmd.txt )

PATCHES=( "${FILESDIR}"/${P}-jxl-mime.patch )

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# FIXME @upstream:
	einfo "Converting doc/cmd.txt to UTF-8"
	iconv -f LATIN1 -t UTF-8 doc/cmd.txt > doc/cmd.txt.tmp || die
	mv -f doc/cmd.txt.tmp doc/cmd.txt || die

	cmake_src_prepare

	sed -e "/^include.*compilerFlags/s/^/#DONT /" -i CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14
		-DEXIV2_BUILD_SAMPLES=NO
		-DEXIV2_ENABLE_NLS=$(usex nls)
		-DEXIV2_ENABLE_PNG=$(usex png)
		-DEXIV2_ENABLE_CURL=$(usex webready)
		-DEXIV2_ENABLE_SSH=$(usex webready)
		-DEXIV2_ENABLE_WEBREADY=$(usex webready)
		-DEXIV2_ENABLE_XMP=$(usex xmp)
		-DEXIV2_ENABLE_BMFF=$(usex bmff)
		$(multilib_is_native_abi || echo -DEXIV2_BUILD_EXIV2_COMMAND=NO)
		$(multilib_is_native_abi && echo -DEXIV2_BUILD_DOC=$(usex doc))
		$(multilib_is_native_abi && echo -DEXIV2_BUILD_UNIT_TESTS=$(usex test))
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi; then
		use doc && eninja doc
	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		cd "${BUILD_DIR}"/bin || die
		./unit_tests || die "Failed to run tests"
	fi
}

multilib_src_install_all() {
	use xmp && DOCS+=( doc/{COPYING-XMPSDK,README-XMP,cmdxmp.txt} )

	einstalldocs
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc samples/*.cpp
	fi
}
