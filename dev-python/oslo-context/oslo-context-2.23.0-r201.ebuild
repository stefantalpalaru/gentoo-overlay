# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN/-/.}"

inherit distutils-r1 pypi

DESCRIPTION="Helpers to maintain useful information about a request context"
HOMEPAGE="https://pypi.org/project/oslo.context/
		https://github.com/openstack/oslo.context"
S="${WORKDIR}/oslo.context-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	>=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	!<dev-python/oslo-context-2.23.0-r200[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

# This time half the doc files are missing; Do you want them?
python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
