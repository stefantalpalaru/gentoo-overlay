# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 flag-o-matic pypi virtualx

DESCRIPTION="Python interface to the R Programming Language"
HOMEPAGE="https://rpy2.github.io/
	https://github.com/rpy2/rpy2
	https://pypi.org/project/rpy2/"
LICENSE="AGPL-3 GPL-2 LGPL-2.1 MPL-1.1"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

# ggplot2 is a test dep but not in portage
RESTRICT="test"

RDEPEND="
	>=dev-lang/R-3.2
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.13.1:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/rpy2-2.8.6-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/R-3.2[X,png] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

python_compile() {
	local CFLAGS=${CFLAGS}
	append-cflags -fno-strict-aliasing -fpermissive
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	virtx "${EPYTHON}" -m 'rpy2.tests'
}
