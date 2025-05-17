# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=true
DISTUTILS_EXT=1

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="https://pysvn.sourceforge.io/"
SRC_URI="https://sourceforge.net/projects/pysvn/files/pysvn/V${PV}/${P}.tar.gz"
LICENSE="Apache-1.1"
SLOT="python2"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples"
RESTRICT="mirror"

DEPEND="
	>=dev-python/pycxx-6.2.6:python2[${PYTHON_USEDEP}]
	dev-vcs/subversion"
RDEPEND="${DEPEND}
	!<dev-python/pysvn-1.9.11-r200[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-respect_flags.patch )

python_prepare_all() {
	# Don't use internal copy of dev-python/pycxx.
	rm -r Import || die

	distutils-r1_python_prepare_all
}

python_configure() {
	cd Source || die
	# all config options from 1.7.6 are all already set
	esetup.py configure
}

python_compile() {
	cd Source || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

python_test() {
	cd Tests || die
	emake
}

python_install() {
	cd Source || die
	python_domodule pysvn
}

python_install_all() {
	use doc && local HTML_DOCS=( Docs/. )
	use examples && local EXAMPLES=( Examples/Client/. )
	distutils-r1_python_install_all
}
