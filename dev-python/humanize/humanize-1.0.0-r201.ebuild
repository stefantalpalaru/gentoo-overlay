# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS="manual"

inherit distutils-r1

DESCRIPTION="Common humanization utilities"
HOMEPAGE="https://github.com/jmoiron/humanize/"
# Tests are not included in PyPI tarballs
# https://github.com/jmoiron/humanize/issues/33
SRC_URI="https://github.com/jmoiron/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"
RDEPEND="
	!<dev-python/humanize-1.0.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e '/_scm/d' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build . _build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
