# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"

inherit distutils-r1 pypi

DESCRIPTION="Fast, pure-Python full text indexing, search and spell checking library"
HOMEPAGE="https://pypi.org/project/Whoosh/"
S="${WORKDIR}/${P^}"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~x64-solaris"
RESTRICT="mirror test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.4-tests-specify-utf8.patch
)

distutils_enable_sphinx docs/source

python_prepare_all() {
	# (backport from upstream)
	sed -i -e '/cmdclass/s:pytest:PyTest:' setup.py || die
	# fix old section name
	sed -i -e 's@\[pytest\]@[tool:pytest]@' setup.cfg || die
	# TODO: broken?
	sed -i -e 's:test_minimize_dfa:_&:' tests/test_automata.py || die

	distutils-r1_python_prepare_all
}
