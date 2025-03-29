# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="an easy whitelist-based HTML-sanitizing tool"
HOMEPAGE="https://github.com/mozilla/bleach
		https://pypi.org/project/bleach/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1-r1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]
	!<dev-python/bleach-3.2.1-r2[${PYTHON_USEDEP}]
"

src_prepare() {
	# unbundle unpatched broken html5lib
	rm -r bleach/_vendor || die
	sed -i -e 's:bleach\._vendor\.::' \
		bleach/html5lib_shim.py tests/test_clean.py || die

	distutils-r1_src_prepare
}
