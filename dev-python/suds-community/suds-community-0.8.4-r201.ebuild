# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_PN="${PN}-community"
DESCRIPTION="Lightweight SOAP client"
HOMEPAGE="https://github.com/suds-community/suds"
LICENSE="LGPL-3"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="
	!<dev-python/suds-community-0.8.4-r200[${PYTHON_USEDEP}]
"

# https://github.com/suds-community/suds/pull/40
PATCHES=(
	"${FILESDIR}/suds-0.8.4-fix-optimization.patch"
)

DOCS=( README.md notes/. )
