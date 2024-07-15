# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A python logging module similar to log4j"
HOMEPAGE="https://sourceforge.net/projects/log4py/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE="doc"
DOCS="doc/AUTHORS doc/ChangeLog database/* log4py-test.py"

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}

python_install() {
	distutils-r1_python_install
	insinto /etc
	doins log4py.conf
}
