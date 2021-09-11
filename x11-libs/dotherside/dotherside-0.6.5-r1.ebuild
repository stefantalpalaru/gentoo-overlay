# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake virtualx

DESCRIPTION="C language library for creating bindings for the Qt QML language"
HOMEPAGE="https://github.com/filcuc/DOtherSide"
SRC_URI="https://github.com/filcuc/dotherside/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_build doc
	fi
}

src_test() {
	virtx "${BUILD_DIR}/test/TestDynamicQObject" || die
}

src_install() {
	cmake_src_install

	if use static-libs; then
		dolib.a "${BUILD_DIR}/lib/libDOtherSideStatic.a"
	fi

	if use doc; then
		dodoc -r "${BUILD_DIR}/doc/doc/html"
	fi
}
