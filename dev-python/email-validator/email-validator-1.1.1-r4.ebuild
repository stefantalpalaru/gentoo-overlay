# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A robust email syntax and deliverability validation library"
HOMEPAGE="https://github.com/JoshData/python-email-validator"
SRC_URI="https://github.com/JoshData/python-email-validator/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/python-${P}"
LICENSE="CC0-1.0"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND="
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
	!<dev-python/email-validator-1.1.1-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# deliverability tests fail within network-sandbox
	sed -e 's:test_deliverability_:_&:' \
		-i tests/test_main.py || die

	sed -i \
		-e "s/'email_validator=email_validator:main'/'email_validator_py2=email_validator:main'/" \
		setup.py || die

	distutils-r1_python_prepare_all
}
