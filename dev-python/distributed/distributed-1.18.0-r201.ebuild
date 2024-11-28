# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python library for distributed computation"
HOMEPAGE="https://distributed.readthedocs.io/en/latest/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/click:python2[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-0.2.2:python2[${PYTHON_USEDEP}]
	>=dev-python/dask-0.14.1:python2[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.10.2:python2[${PYTHON_USEDEP}]
	dev-python/msgpack:python2[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.7:python2[${PYTHON_USEDEP}]
	dev-python/psutil:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	dev-python/sortedcollections[${PYTHON_USEDEP}]
	dev-python/tblib:python2[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.7.4:python2[${PYTHON_USEDEP}]
	dev-python/zict[${PYTHON_USEDEP}]
	dev-python/tornado:python2[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	!<dev-python/distributed-1.18.0-r4[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	py.test -vv -m "not avoid_travis" distributed \
		-r s \
		--timeout-method=thread \
		--timeout=300 \
		--durations=20 || die
}
