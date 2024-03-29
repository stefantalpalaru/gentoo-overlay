# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN%-python}
MY_P=${MY_PN}-${PV}
DESCRIPTION="AWS X-Ray SDK for Python"
HOMEPAGE="https://github.com/aws/aws-xray-sdk-python
		https://pypi.org/project/aws-xray-sdk/"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND=">=dev-python/botocore-1.11.3:python2[${PYTHON_USEDEP}]
	dev-python/future:python2[${PYTHON_USEDEP}]
	dev-python/jsonpickle:python2[${PYTHON_USEDEP}]
	dev-python/wrapt:python2[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	!<dev-python/aws-xray-sdk-python-2.4.3-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RESTRICT="test"
S=${WORKDIR}/${MY_P}

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
