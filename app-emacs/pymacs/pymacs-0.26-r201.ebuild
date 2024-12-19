# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="A tool that allows both-side communication beetween Python and Emacs Lisp"
HOMEPAGE="https://www.emacswiki.org/emacs/PyMacs"
SRC_URI="https://github.com/dgentry/${PN^}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P^}"
LICENSE="GPL-2+"
SLOT="python2"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	!app-emacs/pymacs:0
	!<app-emacs/pymacs-0.26-r2[${PYTHON_USEDEP}]
"

# called by distutils-r1 for every python implementation
python_configure() {
	# pre-process the files but don't run distutils
	emake PYSETUP=: PYTHON=${EPYTHON}
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc pymacs.rst
	rm -rf "${ED}/usr/share/emacs"
}
