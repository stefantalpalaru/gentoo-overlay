# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A python module to inject warning filters during nosetest"
HOMEPAGE="https://github.com/Carreau/nose_warnings_filters"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm64 ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/nose:python2[${PYTHON_USEDEP}]
	!<dev-python/nose_warnings_filters-0.1.5-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_test() {
	# nose_warnings_filters doesn't have a proper
	# testing suite, hence we run the only testing
	# script available
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	"${EPYTHON}" "${S}"/${PN}/testing/test_config.py || die "Failed running test script"
}
