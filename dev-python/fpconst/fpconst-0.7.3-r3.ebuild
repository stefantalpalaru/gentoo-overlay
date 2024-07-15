# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Module for handling IEEE 754 floating point special values"
HOMEPAGE="http://chaco.bst.rochester.edu:8080/statcomp/projects/RStatServer/fpconst/
	https://pypi.org/project/fpconst/
	https://sourceforge.net/projects/rsoap/files/"
SRC_URI="https://downloads.sourceforge.net/rsoap/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
DOCS=( CHANGELOG README pep-0754.txt )

python_test() {
	"${PYTHON}" -m fpconst || die "Self-tests fail with ${EPYTHON}"
}
