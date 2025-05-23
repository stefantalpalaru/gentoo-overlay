# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python module used for monitoring filesystems events"
HOMEPAGE="
	http://trac.dbzteam.org/pyinotify
	https://pypi.org/project/pyinotify/
	https://github.com/seb-m/pyinotify/"
SRC_URI="http://seb.dbzteam.org/pub/pyinotify/releases/${P}.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/pyinotify-0.9.6-r200[${PYTHON_USEDEP}]
"

python_install_all() {
	if use examples; then
		dodoc -r python3/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
