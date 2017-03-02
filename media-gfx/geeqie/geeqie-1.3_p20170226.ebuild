# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
EGIT_REPO_URI="git://www.geeqie.org/geeqie.git"
EGIT_COMMIT="d8c800519440afcea5391392b20e2ebe3d8dd5b4"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc exif gpu-accel gtk3 jpeg lcms lirc lua map tiff xmp"

RDEPEND="gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	virtual/libintl
	doc? ( app-text/gnome-doc-utils )
	gpu-accel? ( media-libs/clutter-gtk )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	lirc? ( app-misc/lirc )
	lua? ( >=dev-lang/lua-5.1:= )
	map? ( media-libs/libchamplain:0.12 )
	xmp? ( >=media-gfx/exiv2-0.17:=[xmp] )
	!xmp? ( exif? ( >=media-gfx/exiv2-0.17:= ) )
	tiff? ( media-libs/tiff:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

REQUIRED_USE="gpu-accel? ( gtk3 )
	map? ( gpu-accel )"

PATCHES=(
	"${FILESDIR}"/version-fix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# clutter does not compile, gps depends on clutter
	local myconf="--disable-dependency-tracking
		--with-readmedir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug debug-log)
		$(use_enable gpu-accel)
		$(use_enable gtk3)
		$(use_enable jpeg)
		$(use_enable lcms)
		$(use_enable lua)
		$(use_enable lirc)
		$(use_enable map)
		$(use_enable tiff)"

	if use exif || use xmp; then
		myconf="${myconf} --enable-exiv2"
	else
		myconf="${myconf} --disable-exiv2"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	rm -f "${D}/usr/share/doc/${PF}/COPYING"
	# Application needs access to the uncompressed file
	docompress -x /usr/share/doc/${PF}/README
}

pkg_postinst() {
	elog "Some plugins may require additional packages"
	elog "- Image rotate plugin: media-gfx/fbida (JPEG), media-gfx/imagemagick (TIFF/PNG)"
	elog "- RAW images plugin: media-gfx/ufraw"
}
