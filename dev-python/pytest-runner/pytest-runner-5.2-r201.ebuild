# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Adds support for tests during installation of setup.py files"
HOMEPAGE="https://pypi.org/project/pytest-runner/
		https://github.com/pytest-dev/pytest-runner"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
# Tests require network access to download packages
RESTRICT="test"

RDEPEND="dev-python/pytest:python2[${PYTHON_USEDEP}]
	!<dev-python/pytest-runner-5.2-r200[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/setuptools-40.6.3[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	doc? (
		dev-python/jaraco-packaging[${PYTHON_USEDEP}]
		dev-python/rst-linker[${PYTHON_USEDEP}]
	)
	test? ( ${RDEPEND} )
"

distutils_enable_sphinx docs

python_test() {
	esetup.py pytest
}
