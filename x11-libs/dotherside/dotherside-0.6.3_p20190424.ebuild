# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils virtualx

my_commit="483c1848e20f056649afa3e155c84a6d0cbcf907"

DESCRIPTION="C language library for creating bindings for the Qt QML language"
HOMEPAGE="https://github.com/filcuc/DOtherSide"
SRC_URI="https://github.com/filcuc/DOtherSide/archive/${my_commit}.zip -> ${P}.zip"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest )
	virtual/pkgconfig
"
REQUIRED_USE="
	test? ( static-libs )
"

S="${WORKDIR}/DOtherSide-${my_commit}"

PATCHES=(
	"${FILESDIR}/dotherside-skip-tests.patch"
	"${FILESDIR}/dotherside-cmake.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(usex doc ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_STATIC_LIBS=$(usex static-libs ON OFF)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make

	if use doc; then
		cmake-utils_src_make doc
	fi
}

src_test() {
	virtx "${BUILD_DIR}/test/TestDynamicQObject" || die
}

src_install() {
	cmake-utils_src_install

	if use static-libs; then
		dolib.a "${BUILD_DIR}/lib/libDOtherSideStatic.a"
	fi

	if use doc; then
		dodoc -r "${BUILD_DIR}/doc/doc/html"
	fi
}
