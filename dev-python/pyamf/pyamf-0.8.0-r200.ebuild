# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=PyAMF
MY_P=${MY_PN}-${PV}

DESCRIPTION="Action Message Format (AMF) support for Python"
HOMEPAGE="https://github.com/hydralabs/pyamf https://pypi.org/project/PyAMF/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/defusedxml:python2[${PYTHON_USEDEP}]
	!<dev-python/pyamf-0.8.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_test() {
	esetup.py test
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "PyAMF optionally integrates with several third-party libraries"
		elog "and web frameworks. See the README or the Optional Extras section at"
		elog "https://github.com/hydralabs/pyamf/blob/master/doc/install.rst"
	fi
}
