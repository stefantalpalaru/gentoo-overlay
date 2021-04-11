# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="An Amazon S3 Transfer Manager"
HOMEPAGE="https://github.com/boto/s3transfer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	>=dev-python/botocore-1.3.0:python2[${PYTHON_USEDEP}]
	<dev-python/botocore-2.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/futures-2.2.0[${PYTHON_USEDEP}]
	<dev-python/futures-4.0.0[${PYTHON_USEDEP}]
"
# Pin mock to 1.3.0 if testing failures due to mock occur.
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}
	!<dev-python/s3transfer-0.1.11-r200[${PYTHON_USEDEP}]
"

python_test() {
	nosetests tests/unit/ tests/functional/ || die "tests failed under ${EPYTHON}"
}
