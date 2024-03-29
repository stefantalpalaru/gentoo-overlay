# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Abstraction layer for PyQt5/PySide"
HOMEPAGE="https://github.com/spyder-ide/qtpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="designer gui opengl printsupport svg testlib webengine"
RESTRICT="test"

RDEPEND="
	dev-python/PyQt5[${PYTHON_USEDEP},designer?,opengl?,printsupport?,svg?]
	gui? ( dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets] )
	testlib? ( dev-python/PyQt5[${PYTHON_USEDEP},testlib] )
	webengine? ( dev-python/PyQtWebEngine[${PYTHON_USEDEP}] )
	!<dev-python/QtPy-1.9.0-r3[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	default

	sed -i -e "s/from PyQt4.Qt import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide2 import/raise ImportError #/" qtpy/__init__.py || die
}
