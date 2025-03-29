# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python parser for the CommonMark Markdown spec"
HOMEPAGE="https://github.com/readthedocs/commonmark.py"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

BDEPEND="
	test? (
		>=dev-python/flake8-3.5.8[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.55.3[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/future-0.14.0[${PYTHON_USEDEP}]
	!<dev-python/commonmark-0.9.1-r3[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py

src_test() {
	local -x PYTHONIOENCODING='utf8'
	distutils-r1_src_test
}

src_prepare() {
	default
	# Fix file collision with app-text/cmark, see bug #627034
	sed -i -e "s:'cmark\( = commonmark.cmark\:main'\):'cmark_py2.py\1:" \
		setup.py || die
}

pkg_postinst() {
	ewarn "/usr/bin/cmark has been renamed to /usr/bin/cmark.py due file"
	ewarn "collision with app-text/cmark (see bug #627034)"
}
