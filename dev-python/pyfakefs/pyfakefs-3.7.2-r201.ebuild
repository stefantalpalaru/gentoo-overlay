# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="a fake file system that mocks the Python file system modules"
HOMEPAGE="https://github.com/jmcgeheeiv/pyfakefs/
		https://pypi.org/project/pyfakefs/"
SRC_URI="https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

COMMON_DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pyfakefs-3.7.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	"${EPYTHON}" -m pyfakefs.tests.all_tests -v || die "tests failed under ${EPYTHON}"
}
