# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Highly concurrent networking library"
HOMEPAGE="https://pypi.org/project/eventlet/
		https://github.com/eventlet/eventlet/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

RDEPEND="
	>=dev-python/dnspython-1.15.0:python2[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3:python2[${PYTHON_USEDEP}]
	>=dev-python/monotonic-1.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0:python2[${PYTHON_USEDEP}]
	!<dev-python/eventlet-0.25.1-r3[${PYTHON_USEDEP}]
"
DEPEND="doc? ( >=app-doc/python-docs-2.7.6-r1:2.7 )
	test? ( ${RDEPEND}
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/eventlet-0.25.1-tests.patch"
)

distutils_enable_sphinx doc
distutils_enable_tests nose

python_prepare_all() {
	# provided by virtual/python-enum34
	sed -i '/enum-compat/d' setup.py || die

	if use doc; then
		local PYTHON_DOC_ATOM=$(best_version -b app-doc/python-docs:2.7)
		local PYTHON_DOC_VERSION="${PYTHON_DOC_ATOM#app-doc/python-docs-}"
		local PYTHON_DOC="/usr/share/doc/python-docs-${PYTHON_DOC_VERSION}/html"
		local PYTHON_DOC_INVENTORY="${PYTHON_DOC}/objects.inv"
		sed -i "s|'https://docs.python.org/': None|'${PYTHON_DOC}': '${PYTHON_DOC_INVENTORY}'|" doc/conf.py || die
	fi

	if use test; then
#		sed -i '/This is a Python 3 module/d' eventlet/green/http/__init__.py || die
#		sed -i 's/^import/from OpenSSL import/g' eventlet/green/OpenSSL/__init__.py || die
#		sed -i 's/^from version/from OpenSSL.version/' eventlet/green/OpenSSL/__init__.py || die
		sed -i 's/TEST_TIMEOUT = 1/TEST_TIMEOUT = 10/' tests/__init__.py || die
	fi

	# Prevent file collisions from teestsuite
	sed -e "s:'tests', :'tests', 'tests.*', :" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_prepare() {
	if ! python_is_python3; then
		# this is for python3 only
		rm -r eventlet/green/http || die
	fi
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi
	distutils-r1_python_install_all
}
