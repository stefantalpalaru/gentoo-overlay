# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Extension to sphinx to create links to issue trackers"
HOMEPAGE="http://sphinxcontrib-issuetracker.readthedocs.org/"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/requests:python2[${PYTHON_USEDEP}]
	dev-python/sphinx:python2[${PYTHON_USEDEP}]
	!<dev-python/sphinxcontrib-issuetracker-0.11-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# test requires network access (bug #425694)
	rm tests/test_builtin_trackers.py || die

	# Tests from tests/test_stylesheet.py require dev-python/pyqt4[X,webkit]
	# and virtualx.eclass.
	rm tests/test_stylesheet.py || die

	# Avoid redundant objects.inv from downloading, sed more lightweight
	if use doc; then
		sed -e "s:^intersphinx_mapping:#intersphinx_mapping:" \
			-e "s:^                       'sphinx':#:" \
			-i doc/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	py.test || die
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
