# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Pythonic file interface to S3"
HOMEPAGE="https://s3fs.readthedocs.io/en/latest/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/boto3-1.9.91:python2[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.12.91:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0:python2[${PYTHON_USEDEP}]
	!<dev-python/s3fs-0.2.2-r200[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test -v || die
}
