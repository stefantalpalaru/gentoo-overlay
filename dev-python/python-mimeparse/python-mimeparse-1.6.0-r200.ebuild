# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Basic functions for handling mime-types in python"
HOMEPAGE="https://github.com/dbtsai/python-mimeparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<dev-python/python-mimeparse-1.6.0-r200[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" mimeparse_test.py -v || die "Tests fail with ${EPYTHON}"
}
