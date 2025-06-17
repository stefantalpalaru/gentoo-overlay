# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="A better directory iterator and faster os.walk()"
HOMEPAGE="https://github.com/benhoyt/scandir"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~x64-solaris"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	!<dev-python/scandir-1.10.0-r200[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} test/run_tests.py -v || die "tests failed under ${EPYTHON}"
}
