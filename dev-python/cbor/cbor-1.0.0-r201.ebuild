# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="RFC 7049 - Concise Binary Object Representation"
HOMEPAGE="https://bitbucket.org/bodhisnarkva/cbor
		https://pypi.org/project/cbor/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="${DEPEND}
	!<dev-python/cbor-1.0.0-r200[${PYTHON_USEDEP}]
"
