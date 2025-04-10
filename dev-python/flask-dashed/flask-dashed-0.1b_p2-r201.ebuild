# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

MY_PN="Flask-Dashed"
MY_PV="${PV/_p/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Admin app framework for flask"
HOMEPAGE="https://github.com/jeanphix/Flask-Dashed
		https://pypi.org/project/Flask-Dashed/"
SRC_URI="$(pypi_sdist_url --no-normalize ${MY_PN} ${MY_PV})"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-python/flask:python2[${PYTHON_USEDEP}]
	dev-python/flask-wtf:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-dashed-0.1b_p2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	distutils-r1_src_prepare
	rm -rf "${S}/tests" || die
}

src_install() {
	distutils-r1_src_install
	rm "${ED}/usr/README"
}
