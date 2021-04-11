# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Getting image size from png/jpeg/jpeg2000/gif file"
HOMEPAGE="https://github.com/shibukawa/imagesize_py"
SRC_URI="https://github.com/shibukawa/imagesize_py/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="test"

DEPEND="dev-python/setuptools"
RDEPEND="
	!<dev-python/imagesize-1.1.0-r2[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
