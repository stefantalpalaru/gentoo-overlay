# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="Glymur"
PYPI_NO_NORMALIZE=1
MYPN=Glymur
MYP=${MYPN}-${PV}

inherit distutils-r1 pypi

DESCRIPTION="Python tools for accessing JPEG2000 files"
HOMEPAGE="https://github.com/quintusdias/glymur"
S="${WORKDIR}/${MYP}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-python/contextlib2:python2[${PYTHON_USEDEP}]
	dev-python/lxml:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	media-libs/openjpeg:2=
	!<dev-python/glymur-0.8.10-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	"${EPYTHON}" -m unittest discover || die
}
