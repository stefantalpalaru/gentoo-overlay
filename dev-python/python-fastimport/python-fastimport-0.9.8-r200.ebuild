# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN#python-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Library for parsing the fastimport VCS serialization format"
HOMEPAGE="https://github.com/jelmer/python-fastimport"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND="
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	!<dev-python/python-fastimport-0.9.8-r200[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	for F in bin/*; do
		mv "${F}" "${F}_py2" || die
	done
	sed -i \
		-e 's#bin/fast-import-query#bin/fast-import-query_py2#' \
		-e 's#bin/fast-import-filter#bin/fast-import-filter_py2#' \
		-e 's#bin/fast-import-info#bin/fast-import-info_py2#' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" -m unittest -v fastimport.tests.test_suite \
		|| die "Tests fail with ${EPYTHON}"
}
