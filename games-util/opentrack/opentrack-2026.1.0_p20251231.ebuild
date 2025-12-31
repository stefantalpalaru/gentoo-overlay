# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="93212320b990f19b880593e3e2d7b82033a165d4"

inherit cmake desktop

DESCRIPTION="Head tracking software for MS Windows, Linux, and Apple OSX"
HOMEPAGE="https://github.com/opentrack/opentrack"
SRC_URI="https://github.com/opentrack/opentrack/archive/${MY_COMMIT}.tar.gz -> ${PN}-${MY_COMMIT}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+neuralnet +wine"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtserialport:6
	dev-qt/qttools:6[linguist]
	media-libs/opencv
	neuralnet? (
		sci-libs/onnxruntime:=
	)
	sys-process/procps
	wine? (
		virtual/wine
	)
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/opentrack-2024.1.0-flags.patch
	"${FILESDIR}"/opentrack-2024.1.1_onnxruntime.patch
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
	# https://github.com/gentoo/gentoo/pull/37646 :
	# Installing in "/opt/opentrack" allows the Wine components to be visible in
	# Valve's pressure-vessel which replaces "/usr" with the container runtime.
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt/opentrack
		-DSDK_WINE=$(usex wine)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dosym -r /opt/opentrack/bin/opentrack /usr/bin/opentrack

	newicon gui/images/opentrack.png opentrack.png
	make_desktop_entry /usr/bin/opentrack OpenTrack /usr/share/pixmaps/opentrack.png Utility
}

pkg_postinst() {
	if use wine; then
		elog "Make sure the version of Wine you want to target has been selected"
		elog "with 'eselect wine ...' before building this package."
		elog
		elog "Useful configuration guide: https://markx86.github.io/opentrack-wine-guide/#setting-up-opentrack"
	fi
}
