# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1 pypi

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="http://pytest.org/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# When bumping, please check setup.py for the proper py version
PY_VER="1.5.0"

# pathlib2 has been added to stdlib before py3.6, but pytest needs __fspath__
# support, which only came in py3.6.
RDEPEND="
	>=dev-python/atomicwrites-1.0:python2[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.4.0:python2[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0:python2[${PYTHON_USEDEP}]
	<dev-python/more-itertools-6.0.0:python2[${PYTHON_USEDEP}]
	dev-python/pathlib2:python2[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.7:python2[${PYTHON_USEDEP}]
	>=dev-python/py-${PY_VER}:python2[${PYTHON_USEDEP}]
	>=dev-python/setuptools-40:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0:python2[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]
	!<dev-python/pytest-3.10.1-r1[${PYTHON_USEDEP}]
"

# flake & pytest-capturelog cause a number of tests to fail
DEPEND="${RDEPEND}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		!!dev-python/flaky
		!!dev-python/pytest-capturelog
	)"

python_prepare_all() {
	grep -qF "py>=${PY_VER}" setup.py || die "Incorrect dev-python/py dependency"

	# Something in the ebuild environment causes this to hang/error.
	# https://bugs.gentoo.org/598442
	rm testing/test_pdb.py || die

	# those tests appear to hang with python3.5+;  TODO: investigate why
	sed -i -e 's:test_runtest_location_shown_before_test_starts:_&:' \
		testing/test_terminal.py || die
	sed -i -e 's:test_trial_pdb:_&:' testing/test_unittest.py || die

	sed -i \
		-e 's/pytest=pytest:main/pytest_py2=pytest:main/' \
		-e 's/py.test=pytest:main/py.test_py2=pytest:main/' \
		setup.cfg

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" "${BUILD_DIR}"/lib/pytest.py --lsof -rfsxX \
		-vv testing || die "tests failed with ${EPYTHON}"
}
