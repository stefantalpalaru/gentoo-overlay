# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic

DESCRIPTION="A Python extension module for cdb"
HOMEPAGE="http://pilcrow.madison.wi.us/#pycdb"
SRC_URI="http://pilcrow.madison.wi.us/python-cdb/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
RESTRICT="mirror"

DEPEND="|| ( dev-db/cdb dev-db/tinycdb )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	append-cflags -fpermissive
}

python_test() {
	"${PYTHON}" setup.py build -b "build-${PYTHON_ABI}" install --home "${T}/test-${PYTHON_ABI}" || return 1
	# This is not really intended as test but it is better than nothing.
	"${PYTHON}" < Example
}
