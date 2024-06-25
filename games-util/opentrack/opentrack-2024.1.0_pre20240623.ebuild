# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
MY_COMMIT="225c98bab109872e5cd0687a1564c1531744c3cb"

DESCRIPTION="Head tracking software for MS Windows, Linux, and Apple OSX"
HOMEPAGE="https://github.com/opentrack/opentrack"
#SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
SRC_URI="https://github.com/opentrack/opentrack/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/${PN}-${P}"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+wine"

DEPEND="
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/opencv
	sys-process/procps
	wine? (
		virtual/wine
	)
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/opentrack-2024.1.0-flags.patch
)

src_prepare() {
	sed -i \
		-e "s%share/doc/opentrack%share/doc/${P}%" \
		cmake/opentrack-hier.cmake || die

	sed -i \
		-e '/REMOVE_RECURSE/d' \
		-e 's%"${CMAKE_INSTALL_PREFIX}/%"%' \
		cmake/opentrack-i18n.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSDK_WINE=$(usex wine)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	if use wine; then
		elog "Make sure the version of Wine you want to target has been selected"
		elog "with 'eselect wine ...' before building this package."
	fi
}