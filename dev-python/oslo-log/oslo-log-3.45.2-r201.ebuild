# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN/-/.}"

inherit distutils-r1 pypi

DESCRIPTION="OpenStack logging config library, configuration for all openstack projects."
HOMEPAGE="https://pypi.org/project/oslo.log/
		https://github.com/openstack/oslo.log"
S="${WORKDIR}/oslo.log-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

CDEPEND=">=dev-python/pbr-3.1.1:python2[${PYTHON_USEDEP}]"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-2.25.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.19.0[${PYTHON_USEDEP}]
	>=dev-python/pyinotify-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/monotonic-1.4[${PYTHON_USEDEP}]
	!<dev-python/oslo-log-3.45.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}"
python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	sed -i \
		-e 's/convert-json = oslo_log.cmds.convert_json:main/convert-json_py2 = oslo_log.cmds.convert_json:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests oslo_log/tests || die "Tests fail with ${EPYTHON}"
}
