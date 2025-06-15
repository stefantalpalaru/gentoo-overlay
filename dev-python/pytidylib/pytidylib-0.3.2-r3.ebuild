# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for HTML Tidy (tidylib)"
HOMEPAGE="http://countergram.com/open-source/pytidylib
	https://github.com/countergram/pytidylib"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="app-text/htmltidy
	!<dev-python/pytidylib-0.3.2-r2[${PYTHON_USEDEP}]
"
DEPEND=${RDEPEND}
