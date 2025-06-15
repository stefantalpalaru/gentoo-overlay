# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_REQ_USE='sqlite?'
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OpenID support for servers and consumers"
HOMEPAGE="http://www.openidenabled.com/openid/libraries/python/
		https://pypi.org/project/python-openid/"
SRC_URI="https://github.com/openid/python-openid/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ppc ppc64 s390 sparc x86"
IUSE="examples mysql postgres sqlite test"
# Tests depend on twill, a broken package. Bug #285169
RESTRICT="mirror test"

RDEPEND="mysql? ( >=dev-python/mysql-python-1.2.2[${PYTHON_USEDEP}] )
	postgres? ( dev-python/psycopg:python2[${PYTHON_USEDEP}] )
	!<dev-python/python-openid-2.2.5-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	local PATCHES=(
		# Patch to fix confusion with localhost/127.0.0.1
		"${FILESDIR}/${PN}-2.0.0-gentoo-test_fetchers.diff"
		"${FILESDIR}"/"${P}-tests.patch"
	)

	# Disable broken tests from from examples/djopenid.
	# Remove test that requires running db server.
	sed -e "s/django_failures =.*/django_failures = 0/" \
		-e '/storetest/d' \
		-i admin/runtests || die "sed admin/runtests failed"

	rm -v openid/test/test_parsehtml.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" admin/runtests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
