# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="https://xarray.pydata.org/
			https://github.com/pydata/xarray"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.19.2[${PYTHON_USEDEP}]
	!<dev-python/xarray-0.11.3-r4[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/dask-0.18.2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/scipy-python2[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.8-skip-broken-test.patch"
)

python_test() {
	pytest -v || die
}
