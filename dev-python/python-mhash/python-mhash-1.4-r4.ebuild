# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python interface to libmhash"
HOMEPAGE="http://mhash.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/mhash/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND="app-crypt/mhash"
RDEPEND="${DEPEND}"

python_configure_all() {
	# Note: review this when py3 is supported
	append-flags -fno-strict-aliasing
}

python_test() {
	"${PYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
