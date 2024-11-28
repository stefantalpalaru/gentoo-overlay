# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Manage versions by scm tags via setuptools"
HOMEPAGE="https://github.com/pypa/setuptools_scm
		https://pypi.org/project/setuptools_scm/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		dev-vcs/git
		!sparc? ( dev-vcs/mercurial ) )"
RDEPEND="
	!<dev-python/setuptools-scm-4.1.2-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# network access
	sed -i -e 's:test_pip_download:_&:' testing/test_regressions.py || die
	# all fetch specific setuptools versions
	rm testing/test_setuptools_support.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pytest -v -v -x || die "Tests fail with ${EPYTHON}"
}
