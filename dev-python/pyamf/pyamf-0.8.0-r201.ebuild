# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=PyAMF
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Action Message Format (AMF) support for Python"
HOMEPAGE="https://github.com/hydralabs/pyamf
		https://pypi.org/project/PyAMF/"
S=${WORKDIR}/${MY_P}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-python/defusedxml:python2[${PYTHON_USEDEP}]
	!<dev-python/pyamf-0.8.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

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
