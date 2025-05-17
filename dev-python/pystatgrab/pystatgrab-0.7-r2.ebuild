# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic

DESCRIPTION=" pystatgrab is a set of Python bindings for the libstatgrab library"
HOMEPAGE="https://www.i-scream.org/pystatgrab/"
SRC_URI="https://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/pystatgrab/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="mirror"

RDEPEND=">=sys-libs/libstatgrab-0.91"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

python_prepare_all() {
	append-flags -fno-strict-aliasing
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test.py || die
}
