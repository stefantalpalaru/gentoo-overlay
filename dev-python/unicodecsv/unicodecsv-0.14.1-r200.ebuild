# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for python stdlib csv module supporting unicode"
HOMEPAGE="https://pypi.org/project/unicodecsv/
		https://github.com/jdunck/python-unicodecsv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm64 hppa ~ia64 ~ppc ~ppc64 sparc x86"

RDEPEND="
	!<dev-python/unicodecsv-0.14.1-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	# un-depend on unittest2
	sed -i -e 's:unittest2 as ::' unicodecsv/test.py || die
	distutils-r1_src_prepare
}
