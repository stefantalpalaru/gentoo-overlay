# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="AWS X-Ray SDK for Python"
HOMEPAGE="https://github.com/aws/aws-xray-sdk-python
		https://pypi.org/project/aws-xray-sdk/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RDEPEND=">=dev-python/botocore-1.11.3:python2[${PYTHON_USEDEP}]
	dev-python/future:python2[${PYTHON_USEDEP}]
	dev-python/jsonpickle:python2[${PYTHON_USEDEP}]
	dev-python/wrapt:python2[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	!<dev-python/aws-xray-sdk-2.4.3-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RESTRICT="test"

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
