# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN/-/.}"

inherit distutils-r1 pypi

DESCRIPTION="library for running  multi-thread, multi-process applications"
HOMEPAGE="https://pypi.org/project/oslo.concurrency/
		https://github.com/openstack/oslo.concurrency"
S="${WORKDIR}/oslo.concurrency-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

CDPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.6.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.6.6[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.6.7[${PYTHON_USEDEP}]
		>=dev-python/openstackdocstheme-1.18.1[${PYTHON_USEDEP}]
		>=dev-python/reno-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
		!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7.0[${PYTHON_USEDEP}]
	!<dev-python/oslo-concurrency-3.31.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^futures/d' test-requirements.txt || die
	sed -i '/^hacking/d' test-requirements.txt || die
	sed -i \
		-e 's/lockutils-wrapper = oslo_concurrency.lockutils:main/lockutils-wrapper_py2 = oslo_concurrency.lockutils:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests ${PN/-/_}/tests/ || die "test failed under ${EPYTHON}"
}
