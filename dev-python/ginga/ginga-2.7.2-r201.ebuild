# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='tk?'

inherit desktop distutils-r1 optfeature pypi xdg-utils virtualx

DESCRIPTION="Astronomical image toolkit for Python"
HOMEPAGE="https://ejeschke.github.io/ginga"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples gtk qt5 test tk"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	media-fonts/roboto
	gtk? (  dev-python/pygobject:3[${PYTHON_USEDEP},cairo] )
	qt5? (
		 dev-python/pyqt5[${PYTHON_USEDEP},help,gui,widgets]
		 dev-python/qtpy:python2[${PYTHON_USEDEP},gui]
	)
	!<dev-python/ginga-2.7.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/qtpy[${PYTHON_USEDEP},gui] )
"

PATCHES=( "${FILESDIR}"/${PN}-no-roboto.patch )

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	virtx esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	rm -r "${ED}"/usr/lib*/*/*/ginga/examples || die
	if use examples; then
		dodoc -r ginga/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	domenu ginga.desktop
}

pkg_postinst() {
	optfeature "Pick, Cuts, Histogram, LineProfile" \
			   dev-python/matplotlib dev-python/scipy
	optfeature "Online help browser" dev-qt/qtwebkit
	optfeature "To save a movie" media-video/mplayer
	optfeature "Speeds up rotation and some transformations" \
			   dev-python/numexpr dev-python/opencv dev-python/pyopencl
	optfeature "Aids in identifying files when opening them" \
			   dev-python/filemagic
	optfeature "Useful for various RGB file manipulations" dev-python/pillow

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
