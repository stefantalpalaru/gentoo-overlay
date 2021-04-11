# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Transport adapter for fetching file:// URLs with the requests python library "
HOMEPAGE="https://github.com/dashea/requests-file"
SRC_URI="https://github.com/dashea/requests-file/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="python2"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/requests-file-1.4.3-r3[${PYTHON_USEDEP}]
"
