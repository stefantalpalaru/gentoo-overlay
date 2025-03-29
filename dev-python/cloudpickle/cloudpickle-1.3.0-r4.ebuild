# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="https://pypi.org/project/cloudpickle/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	!<dev-python/cloudpickle-1.3.0-r3[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	# -s unbreaks some tests
	# https://github.com/cloudpipe/cloudpickle/issues/252
	pytest -svv || die "Tests fail with ${EPYTHON}"
}
