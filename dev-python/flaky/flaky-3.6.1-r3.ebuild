# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Plugin for nose or py.test that automatically reruns flaky tests"
HOMEPAGE="https://pypi.org/project/flaky/
		https://github.com/box/flaky"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	!<dev-python/flaky-3.6.1-r2[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/genty[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
python_test() {
	nosetests --with-flaky --exclude="test_nose_options_example" test/test_nose/ || die
	pytest -k 'example and not options' --doctest-modules test/test_pytest/ || die
	pytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py || die
	nosetests --with-flaky --force-flaky --max-runs 2 test/test_nose/test_nose_options_example.py || die
	pytest --force-flaky --max-runs 2  test/test_pytest/test_pytest_options_example.py || die
}
