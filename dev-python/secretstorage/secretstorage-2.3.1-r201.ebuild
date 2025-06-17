# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="SecretStorage"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Python bindings to FreeDesktop.org Secret Service API."
HOMEPAGE="https://github.com/mitya57/secretstorage
		https://pypi.org/project/SecretStorage/"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	!<dev-python/secretstorage-2.3.1-r200[${PYTHON_USEDEP}]
"
