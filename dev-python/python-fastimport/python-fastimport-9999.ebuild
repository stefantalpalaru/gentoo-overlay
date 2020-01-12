# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Fastimport parser in Python"
HOMEPAGE="https://launchpad.net/${PN}"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jelmer/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
	)"

python_test() {
	local test_runner=( "${PYTHON}" -m unittest )

	if [[ ${EPYTHON} == python2.6 ]]; then
		test_runner=( unit2 )
	fi

	"${test_runner[@]}" fastimport.tests.test_suite \
		|| die "Tests fail with ${EPYTHON}"
}
