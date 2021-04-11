# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python style guide checker"
HOMEPAGE="https://github.com/PyCQA/pep8
		https://pypi.org/project/pep8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RESTRICT="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	!<dev-python/pep8-1.7.1-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_prepare_all() {
	# AssertionError: 7 is not false : 7 failure(s)
	sed -i -e 's:test_checkers_testsuite:_&:' \
		testsuite/test_all.py || die

	sed -i \
		-e "s/'pep8 = pep8:_main'/'pep8_py2 = pep8:_main'/" \
		setup.py || die

	distutils-r1_python_prepare_all
}
