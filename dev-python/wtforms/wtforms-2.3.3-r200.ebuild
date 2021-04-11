# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

MY_PN="WTForms"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="https://wtforms.readthedocs.io/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]
	!<dev-python/wtforms-2.3.3-r200[${PYTHON_USEDEP}]
"

BDEPEND=""

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
