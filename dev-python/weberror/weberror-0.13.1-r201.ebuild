# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="WebError"
MY_P="${MY_PN}-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Web Error handling and exception catching"
HOMEPAGE="https://pypi.org/project/WebError/"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND=">=dev-python/paste-1.7.1:python2[${PYTHON_USEDEP}]
	dev-python/pygments:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/tempita:python2[${PYTHON_USEDEP}]
	dev-python/webob:python2[${PYTHON_USEDEP}]
	!<dev-python/weberror-0.13.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/webtest[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
