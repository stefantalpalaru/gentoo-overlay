# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-Dashed"
MY_PV="${PV/_p/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Admin app framework for flask"
HOMEPAGE="https://github.com/jeanphix/Flask-Dashed https://pypi.org/project/Flask-Dashed/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/flask:python2[${PYTHON_USEDEP}]
	dev-python/flask-wtf:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-dashed-0.1b_p2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils-r1_src_prepare
	rm -rf "${S}/tests" || die
}

src_install() {
	distutils-r1_src_install
	rm "${ED}/usr/README"
}
