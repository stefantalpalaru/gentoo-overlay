# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Getting image size from png/jpeg/jpeg2000/gif file"
HOMEPAGE="https://github.com/shibukawa/imagesize_py"
EGIT_REPO_URI="https://github.com/shibukawa/imagesize_py"
EGIT_COMMIT="9166a28d1836b599b2147b52802d00191022e1f1"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

DEPEND="dev-python/setuptools"
RDEPEND=""

python_test() {
	esetup.py test
}
