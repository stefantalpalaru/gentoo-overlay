# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Tools to provide lightweight pipelining in Python"
HOMEPAGE="https://joblib.readthedocs.io/en/latest/
	https://github.com/joblib/joblib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c doc/ doc/ doc/html || die "docs failed installation"
	fi
}

python_test() {
	py.test -v
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}