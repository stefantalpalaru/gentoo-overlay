# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Curses-based user interface library for Python"
HOMEPAGE="http://urwid.org/
			https://pypi.org/project/urwid/"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/urwid-2.1.0-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
distutils_enable_tests setup.py

src_prepare() {
	# optional tests broken by modern tornado versions
	sed -e 's:import tornado:&_broken:' \
		-i urwid/tests/test_event_loops.py || die
	distutils-r1_src_prepare
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
