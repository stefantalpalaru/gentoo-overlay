# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="QtPy"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Abstraction layer for PyQt5/PySide"
HOMEPAGE="https://github.com/spyder-ide/qtpy"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="designer gui opengl printsupport svg testlib webengine"
RESTRICT="test"

RDEPEND="
	dev-python/pyqt5[${PYTHON_USEDEP},designer?,opengl?,printsupport?,svg?]
	gui? ( dev-python/pyqt5[${PYTHON_USEDEP},gui,widgets] )
	testlib? ( dev-python/pyqt5[${PYTHON_USEDEP},testlib] )
	webengine? ( dev-python/pyqtwebengine[${PYTHON_USEDEP}] )
	!<dev-python/qtpy-1.9.0-r3[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	default

	sed -i -e "s/from PyQt4.Qt import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide2 import/raise ImportError #/" qtpy/__init__.py || die
}
