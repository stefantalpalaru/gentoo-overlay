# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A security linter from OpenStack Security"
HOMEPAGE="https://openstack.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 ~s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/hacking-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-1.0.0
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup-4.6.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.4.5[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/git-python-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	!<dev-python/bandit-1.5.1-r4[${PYTHON_USEDEP}]
"

python_test() {
	stestr init
	stestr run || die
}

python_install_all() {
	distutils-r1_python_install_all
	for binary in bandit bandit-baseline bandit-config-generator; do
		mv "${ED}/usr/bin/${binary}" "${ED}/usr/bin/${binary}_py2"
		mv "${ED}/usr/lib/python-exec/python2.7/${binary}" "${ED}/usr/lib/python-exec/python2.7/${binary}_py2"
	done
}
