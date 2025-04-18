# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="IPv4/IPv6 manipulation library, backport of the ipaddress module"
HOMEPAGE="https://github.com/phihag/ipaddress"
LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i 's:unittest.main():unittest.main(verbosity=2):' \
		test_ipaddress.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test_ipaddress.py || die
}
