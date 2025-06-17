# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Drop-in replacement for python stdlib csv module supporting unicode"
HOMEPAGE="https://pypi.org/project/unicodecsv/
		https://github.com/jdunck/python-unicodecsv"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm64 hppa ~ppc ~ppc64 sparc x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/unicodecsv-0.14.1-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	# un-depend on unittest2
	sed -i -e 's:unittest2 as ::' unicodecsv/test.py || die
	distutils-r1_src_prepare
}
