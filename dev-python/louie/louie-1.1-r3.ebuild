# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"

inherit distutils-r1 pypi

DESCRIPTION="Signal dispatching mechanism for Python"
HOMEPAGE="https://pypi.org/project/Louie/"
S="${WORKDIR}/${P^}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -e "/'nose >= 0.8.3'/d" -i setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
