# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# note the patch below
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Module for determining appropriate platform-specific dirs"
HOMEPAGE="https://github.com/ActiveState/appdirs"
SRC_URI="https://github.com/ActiveState/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=( "${FILESDIR}"/${PN}-1.4.4-distutils.patch )

python_test() {
	"${PYTHON}" test/test_api.py -v || die "Tests fail with ${EPYTHON}"
}
