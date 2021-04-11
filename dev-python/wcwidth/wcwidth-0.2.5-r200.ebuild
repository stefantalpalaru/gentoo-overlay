# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Measures number of Terminal column cells of wide-character codes"
HOMEPAGE="https://pypi.org/project/wcwidth/
		https://github.com/jquast/wcwidth"
SRC_URI="
	https://github.com/jquast/wcwidth/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="python2"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]
	!<dev-python/wcwidth-0.2.5-r200[${PYTHON_USEDEP}]
"

DOCS=()

src_prepare() {
	sed -e 's:--cov-append::' \
		-e 's:--cov-report=html::' \
		-e 's:--cov=wcwidth::' \
		-i tox.ini || die
	sed -i -e 's:test_package_version:_&:' tests/test_core.py || die
	distutils-r1_src_prepare
}
