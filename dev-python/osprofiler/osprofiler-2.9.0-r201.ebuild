# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="OpenStack Profiler Library"
HOMEPAGE="https://launchpad.net/osprofiler
		https://github.com/openstack/osprofiler"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="mirror test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.26.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.2[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.7.1[${PYTHON_USEDEP}]
	!<dev-python/osprofiler-2.9.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/osprofiler = osprofiler.cmd.shell:main/osprofiler_py2 = osprofiler.cmd.shell:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
