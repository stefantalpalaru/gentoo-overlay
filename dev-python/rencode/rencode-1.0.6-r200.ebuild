# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="similar to bencode from the BitTorrent project"
HOMEPAGE="https://github.com/aresch/rencode"
SRC_URI="https://github.com/aresch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="python2"
KEYWORDS="amd64 ~arm ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<dev-python/rencode-1.0.6-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]"
