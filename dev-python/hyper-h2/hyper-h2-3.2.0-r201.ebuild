# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="https://python-hyper.org/h2/en/stable/
		https://pypi.org/project/h2/
		https://github.com/python-hyper/h2"
SRC_URI="https://github.com/python-hyper/h2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/hyperframe-5.2.0:python2[${PYTHON_USEDEP}]
	<dev-python/hyperframe-6.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/hpack-3.0.0:python2[${PYTHON_USEDEP}]
	<dev-python/hpack-4.0.0:python2[${PYTHON_USEDEP}]
	!<dev-python/hyper-h2-3.2.0-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	pytest -vv --hypothesis-profile=travis test ||
		die "Tests fail with ${EPYTHON}"
}
