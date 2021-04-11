# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A plugin for reCAPTCHA and reCAPTCHA Mailhide"
HOMEPAGE="https://github.com/redhat-infosec/python-recaptcha"
SRC_URI="https://github.com/redhat-infosec/python-recaptcha/releases/download/v${PV}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="python2"

RDEPEND="|| ( dev-python/pycryptodome:python2[${PYTHON_USEDEP}] dev-python/pycrypto:python2[${PYTHON_USEDEP}] )
	dev-python/simplejson:python2[${PYTHON_USEDEP}]
	!dev-python/recaptcha-client
	!<dev-python/python-recaptcha-2.0.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
