# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="WebError"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Web Error handling and exception catching"
HOMEPAGE="https://pypi.org/project/WebError/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/paste-1.7.1:python2[${PYTHON_USEDEP}]
	dev-python/pygments:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/tempita:python2[${PYTHON_USEDEP}]
	dev-python/webob:python2[${PYTHON_USEDEP}]
	!<dev-python/weberror-0.13.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/webtest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
