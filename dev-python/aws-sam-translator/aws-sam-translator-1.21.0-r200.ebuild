# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A library that transform SAM templates into AWS CloudFormation templates"
HOMEPAGE="https://github.com/awslabs/serverless-application-model
		https://pypi.org/project/aws-sam-translator/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND="virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.5:python2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.11:python2[${PYTHON_USEDEP}]
	!<dev-python/aws-sam-translator-1.21.0-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RESTRICT="test"

python_test() {
	PYTHONPATH=${BUILD_DIR}/lib \
		esetup.py test || die "tests failed with ${EPYTHON}"
}
