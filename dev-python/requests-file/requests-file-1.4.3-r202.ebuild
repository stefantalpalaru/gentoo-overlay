# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Transport adapter for fetching file:// URLs with the requests python library "
HOMEPAGE="https://github.com/dashea/requests-file"
SRC_URI="https://github.com/dashea/requests-file/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/requests-file-1.4.3-r3[${PYTHON_USEDEP}]
"
