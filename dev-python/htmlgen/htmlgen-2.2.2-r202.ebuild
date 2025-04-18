# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit python-r1

MY_P="HTMLgen"
DESCRIPTION="HTMLgen - Python modules for the generation of HTML documents"
HOMEPAGE="http://soc.if.usp.br/manual/python-htmlgen/html/main.html"
SRC_URI="http://ftp.jaist.ac.jp/pub/pkgsrc/distfiles/py-HTMLgen-2.2.2/HTMLgen.tgz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="${PYTHON_DEPS}
	dev-python/pillow:python2[${PYTHON_USEDEP}]
	!<dev-python/htmlgen-2.2.2-r200[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default
	patch -p0 -i "${FILESDIR}/${P}-python-2.5.patch"
	patch -p1 -i "${FILESDIR}/${PN}-pillow.patch"
}

src_compile() {
	return 0
}

src_install() {
	# doing this manually because their build scripts suck
	local files="HTMLgen.py HTMLcolors.py HTMLutil.py HTMLcalendar.py
	barchart.py colorcube.py imgsize.py NavLinks.py Formtools.py
	ImageH.py ImageFileH.py ImagePaletteH.py GifImagePluginH.py
	JpegImagePluginH.py PngImagePluginH.py"

	mkdir htmlgen || die
	touch htmlgen/__init__.py || die
	ln ${files} htmlgen/ || die
	python_foreach_impl python_domodule htmlgen

	if use doc; then
		# fix the image locations in the docs
		sed -i -e "s;../image/;image/;g" html/* || die "sed failed"
		dodoc html/*
		dodoc -r image
	fi
	dodoc README
}

pkg_postinst() {
	ewarn "htmlgen now resides in its own subdirectory"
	ewarn "so you need to do \"from htmlgen import HTMLgen\" instead of \"import HTMLgen\""
}
