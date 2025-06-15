# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic

MY_P="${P/q/Q}"

DESCRIPTION="Python HTML templating framework for developing web applications"
HOMEPAGE="http://quixote.ca"
SRC_URI="http://ftp.fr.netbsd.org/pub/pkgsrc/distfiles/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}
LICENSE="CNRI-QUIXOTE-2.4"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc test"
# tests require a running quixote server, prob. apt. post install. Tried the demo one but no
RESTRICT="mirror test"

DEPEND="doc? ( dev-python/docutils[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

src_prepare() {
	default
	append-cflags -fno-strict-aliasing
}

python_compile_all() {
	use doc && emake -C doc
}

python_test() {
	nosetests tests || die "tests failed"
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
