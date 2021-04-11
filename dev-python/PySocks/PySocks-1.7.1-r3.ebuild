# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SOCKS client module"
HOMEPAGE="https://github.com/Anorov/PySocks
		https://pypi.org/project/PySocks/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!<dev-python/PySocks-1.7.1-r3[${PYTHON_USEDEP}]
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/PySocks-1.7.1-test_server.patch
	)

	rm test/bin/3proxy || die

	# requires Internet
	sed -i -e 's:test_socks5_proxy_connect_timeout:_&:' \
		test/test_pysocks.py || die

	distutils-r1_src_prepare
}

python_test() {
	python_is_python3 || return
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
