# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A configuration system for Python applications"
HOMEPAGE="https://github.com/ipython/traitlets"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/enum34[${PYTHON_USEDEP}]
	dev-python/ipython_genutils:python2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/traitlets-4.3.3-r200[${PYTHON_USEDEP}]
"
DEPEND="
	doc? (
		dev-python/ipython_genutils[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		)
	"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	pytest -vv traitlets || die
}
