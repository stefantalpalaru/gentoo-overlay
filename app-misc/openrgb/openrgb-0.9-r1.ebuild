# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils udev

DESCRIPTION="Open source RGB lighting control that doesn't depend on manufacturer software"
HOMEPAGE="https://openrgb.org https://gitlab.com/CalcProgrammer1/OpenRGB/"
SRC_URI="https://gitlab.com/CalcProgrammer1/OpenRGB/-/archive/release_${PV}/OpenRGB-release_${PV}.tar.bz2"
S="${WORKDIR}/OpenRGB-release_${PV}"
LICENSE="GPL-2"
# subslot is OPENRGB_PLUGIN_API_VERSION from https://gitlab.com/CalcProgrammer1/OpenRGB/-/blob/master/OpenRGBPluginInterface.h
SLOT="0/2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/hidapi
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	net-libs/mbedtls:=
	virtual/libusb:1
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/OpenRGB-0.9-build-system.patch
	"${FILESDIR}"/OpenRGB-0.7-r1-udev.patch
)

src_prepare() {
	default
	rm -r dependencies/{hidapi,libusb,json,mbedtls}* || die
}

src_configure() {
	# Some plugins require symbols defined in the main binary.
	# The official build system bundles OpenRGB as a submodule instead, and
	# compiles the .cpp file again.
	append-ldflags -Wl,--export-dynamic

	# The build system needs to use "-save-temps" to generate udev rules, and
	# that clashes with "-pipe".
	filter-flags -pipe

	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann" \
		DEFINES+="OPENRGB_EXTRA_PLUGIN_DIRECTORY=\\\\\"\\\"${EPREFIX}/usr/$(get_libdir)/OpenRGB/plugins\\\\\"\\\""
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	dodoc README.md OpenRGB.patch
	udev_dorules 60-openrgb.rules

	# This is for plugins. Upstream doesn't install any headers at all.
	insinto /usr/include/OpenRGB
	find . -name '*.h' -exec cp --parents '{}' "${ED}/usr/include/OpenRGB/" ';' || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
