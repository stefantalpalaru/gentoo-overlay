# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN=python2-pythondialog

inherit distutils-r1 pypi

DESCRIPTION="A Python module for making simple text/console-mode user interfaces"
HOMEPAGE="http://pythondialog.sourceforge.net/ https://pypi.org/project/python2-pythondialog/"
S="${WORKDIR}/python2-${P}"
LICENSE="LGPL-2"
SLOT="python-2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE="doc examples"

RDEPEND="dev-util/dialog"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i doc/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all
}
