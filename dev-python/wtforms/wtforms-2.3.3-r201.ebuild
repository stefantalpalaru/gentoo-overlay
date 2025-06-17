# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="WTForms"
MY_P="${MY_PN}-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="https://wtforms.readthedocs.io/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]
	!<dev-python/wtforms-2.3.3-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# Extension-tests are written for an older version of Django
	# Disable pep8 even when it is installed
	sed \
		-e "s|'ext_django.tests', ||" \
		-e "/import pep8/d" \
		-e "s|has_pep8 = True|has_pep8 = False|" \
		-i tests/runtests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" tests/runtests.py -v || die
}
