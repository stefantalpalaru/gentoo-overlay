# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual
# entry_points is added via [entry_points] in setup.cfg
_DISTUTILS_SETUPTOOLS_WARNED=1

VIRTUALX_REQUIRED="test"

inherit distutils-r1 pypi virtualx

DESCRIPTION="Command Line Interface Formulation Framework"
HOMEPAGE="https://github.com/openstack/cliff"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 arm64 hppa ~mips ~ppc64 s390 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/python-subunit-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.1.0[${PYTHON_USEDEP}]
	)
"
# source files stipulate <sphinx-1.3 however build effected perfectly with sphinx-1.3.1
RDEPEND="
	${CDEPEND}
	>=dev-python/cmd2-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.2[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/unicodecsv-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
	!<dev-python/cliff-2.18.0-r4[${PYTHON_USEDEP}]
"

python_test() {
	stestr init || die "stestr init failed under ${EPYTHON}"
	# needs outside access, so blacklist the test
	virtx stestr run --black-regex cliff.tests.test_app.TestIO.test_writer_encoding
}
