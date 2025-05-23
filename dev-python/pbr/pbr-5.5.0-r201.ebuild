# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Inject some useful and sensible default behaviors into setuptools"
HOMEPAGE="https://github.com/openstack-dev/pbr"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

# git is needed for tests, see https://bugs.launchpad.net/pbr/+bug/1326682 and https://bugs.gentoo.org/show_bug.cgi?id=561038
# docutils is needed for sphinx exceptions... https://bugs.gentoo.org/show_bug.cgi?id=603848
# stestr is run as external tool
BDEPEND="
	test? (
		>=dev-python/wheel-0.32.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/testresources-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.0.3[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.1.0
		dev-vcs/git
	)"
RDEPEND="
	!<dev-python/pbr-5.5.0-r200[${PYTHON_USEDEP}]
"

# This normally actually belongs here.
python_prepare_all() {
	# TODO: investigate
	sed -e s':test_console_script_develop:_&:' \
		-e s':test_console_script_install:_&:' \
		-i pbr/tests/test_core.py || die
	# broken on pypy3
	# https://bugs.launchpad.net/pbr/+bug/1881479
	sed -e 's:test_generates_c_extensions:_&:' \
		-i pbr/tests/test_packaging.py || die
	rm pbr/tests/test_wsgi.py || die "couldn't remove wsgi network tests"

	sed -i \
		-e 's/pbr = pbr.cmd.main:main/pbr_py2 = pbr.cmd.main:main/' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	local -x PATH=${TEST_DIR}/scripts:${PATH}

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	stestr init || die "stestr init failed under ${EPYTHON}"
	stestr run || die "stestr run failed under ${EPYTHON}"
}
