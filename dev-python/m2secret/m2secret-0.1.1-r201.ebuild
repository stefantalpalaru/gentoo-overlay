# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1 pypi

DESCRIPTION="Encryption and decryption module and CLI utility"
HOMEPAGE="http://www.heikkitoivonen.net/m2secret
		https://pypi.org/project/m2secret/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/m2crypto-0.18[${PYTHON_USEDEP}]
"
