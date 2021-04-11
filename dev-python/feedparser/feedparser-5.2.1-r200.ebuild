# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Parse RSS and Atom feeds in Python"
HOMEPAGE="https://github.com/kurtmckee/feedparser
		https://pypi.org/project/feedparser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

# sgmllib is licensed under PSF-2.
LICENSE="BSD-2 PSF-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

REDEPEND="
	!<dev-python/feedparser-5.2.1-r200[${PYTHON_USEDEP}]
"

# Tests have issues with chardet installed, and are just kind of buggy.
RESTRICT="test"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	cp feedparser/feedparsertest.py "${BUILD_DIR}" || die
	ln -s "${S}/feedparser/tests" "${BUILD_DIR}/tests" || die
	cd "${BUILD_DIR}" || die
	"${PYTHON}" feedparsertest.py || die "Testing failed with ${EPYTHON}"
}
