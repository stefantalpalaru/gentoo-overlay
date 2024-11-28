# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="${PN/pyw/PyW}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_PN="${PN/pyw/PyW}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Discrete Wavelet Transforms in Python"
HOMEPAGE="https://pywavelets.readthedocs.io/en/latest/"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	!<dev-python/pywavelets-0.5.2-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"
DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	nosetests -v .
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc -r demo/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
