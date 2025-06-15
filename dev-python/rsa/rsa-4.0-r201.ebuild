# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python RSA implementation"
HOMEPAGE="https://stuvel.eu/rsa
		https://pypi.org/project/rsa/
		https://github.com/sybrenstuvel/python-rsa/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/pyasn1-0.1.3:python2[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
	!<dev-python/rsa-4.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		)
	"

python_prepare_all() {
	sed -i \
		-e 's/pyrsa-priv2pub = rsa.util:private_to_public/pyrsa-priv2pub_py2 = rsa.util:private_to_public/' \
		-e 's/pyrsa-keygen = rsa.cli:keygen/pyrsa-keygen_py2 = rsa.cli:keygen/' \
		-e 's/pyrsa-encrypt = rsa.cli:encrypt/pyrsa-encrypt_py2 = rsa.cli:encrypt/' \
		-e 's/pyrsa-decrypt = rsa.cli:decrypt/pyrsa-decrypt_py2 = rsa.cli:decrypt/' \
		-e 's/pyrsa-sign = rsa.cli:sign/pyrsa-sign_py2 = rsa.cli:sign/' \
		-e 's/pyrsa-verify = rsa.cli:verify/pyrsa-verify_py2 = rsa.cli:verify/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}
