# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=pyRFC3339
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

MY_P=${MY_PN}-${PV}
DESCRIPTION="Generates and parses RFC 3339 timestamps"
HOMEPAGE="https://github.com/kurtraschke/pyRFC3339"
S=${WORKDIR}/${MY_P}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="dev-python/pytz:python2[${PYTHON_USEDEP}]
	!<dev-python/pyrfc3339-1.1-r200[${PYTHON_USEDEP}]
"
DEPEND="test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	nosetests || die
}
