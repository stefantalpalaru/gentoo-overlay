# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="https://www.python-ldap.org/en/latest/
	https://pypi.org/project/python-ldap/
	https://github.com/python-ldap/python-ldap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x86-solaris"

LICENSE="PSF-2"
SLOT="python2"
IUSE="examples sasl ssl test"

# We do not need OpenSSL, it is never directly used:
# https://github.com/python-ldap/python-ldap/issues/224
RDEPEND="
	!dev-python/pyldap
	>=dev-python/pyasn1-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.1.5[${PYTHON_USEDEP}]
	>net-nds/openldap-2.4.11:=[sasl?,ssl?]
	!<dev-python/python-ldap-3.3.1-r200[${PYTHON_USEDEP}]
"
# We do not link against cyrus-sasl but we use some
# of its headers during the build.
BDEPEND="
	>net-nds/openldap-2.4.11:=[sasl?,ssl?]
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx Doc

python_prepare_all() {
	if ! use sasl; then
		sed -i 's/HAVE_SASL//g' setup.cfg || die
	fi
	if ! use ssl; then
		sed -i 's/HAVE_TLS//g' setup.cfg || die
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	# Run all tests which don't require slapd
	local ignored_tests=(
		t_bind.py
		t_cext.py
		t_edit.py
		t_ldapobject.py
		t_ldap_options.py
		t_ldap_sasl.py
		t_ldap_schema_subentry.py
		t_ldap_syncrepl.py
		t_slapdobject.py
	)
	pushd Tests >/dev/null || die
	pytest -vv ${ignored_tests[@]/#/--ignore } \
		|| die "tests failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install() {
	distutils-r1_python_install
	python_optimize
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r Demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
