# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="plugin and hook calling mechanisms for python"
HOMEPAGE="https://pluggy.readthedocs.io/
		https://github.com/pytest-dev/pluggy
		https://pypi.org/project/pluggy/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"

RDEPEND="$(python_gen_cond_dep \
	'dev-python/importlib_metadata[${PYTHON_USEDEP}]' -2 python3_{5,6,7} pypy3)"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}/${PN}"-0.12.0-strip-setuptools_scm.patch )
