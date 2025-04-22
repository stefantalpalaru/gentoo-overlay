# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN/-/.}

inherit distutils-r1 pypi

DESCRIPTION="Oslo Configuration API"
HOMEPAGE="https://launchpad.net/oslo
		https://github.com/openstack/oslo.config"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}")"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

CDEPEND=">=dev-python/pbr-1.3:python2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	!<dev-python/oslo-config-7.0.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	sed -i \
		-e 's/oslo-config-generator = oslo_config.generator:main/oslo-config-generator_py2 = oslo_config.generator:main/' \
		-e 's/oslo-config-validator = oslo_config.validator:main/oslo-config-validator_py2 = oslo_config.validator:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf .testrepository || die "could not remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}
