# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_P="Pyrex-${PV}"

inherit distutils-r1

DESCRIPTION="A language for writing Python extension modules"
HOMEPAGE="https://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/"
SRC_URI="https://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"
RESTRICT="mirror test"

DOCS=( CHANGES.txt README.txt ToDo.txt USAGE.txt )

python_install_all() {
	distutils-r1_python_install_all

	dodoc -r Doc/.

	if use examples; then
		dodoc -r Demos
		docompress -x /usr/share/doc/${PF}/Demos
	fi
}
