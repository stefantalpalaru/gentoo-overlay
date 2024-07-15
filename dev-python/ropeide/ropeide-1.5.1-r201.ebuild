# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1
PYTHON_REQ_USE="tk"

DESCRIPTION="Python refactoring IDE"
HOMEPAGE="http://freecode.com/projects/ropeide https://pypi.org/project/ropeide/"
SRC_URI="https://downloads.sourceforge.net/rope/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-python/rope-0.8.4:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<dev-python/ropeide-1.5.1-r200[${PYTHON_USEDEP}]
"

python_install_all() {
	if use doc; then
		dodoc docs/*.txt || die "dodoc failed"
	fi
	distutils-r1_python_install_all
}
