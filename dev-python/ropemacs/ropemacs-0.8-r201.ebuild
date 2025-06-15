# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi readme.gentoo-r1

DESCRIPTION="Rope in Emacs"
HOMEPAGE="https://github.com/python-rope/ropemacs
	https://pypi.org/project/ropemacs/"
LICENSE="GPL-1+"		# GPL without version
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/rope:python2[${PYTHON_USEDEP}]
	dev-python/ropemode:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<dev-python/ropemacs-0.8-r200[${PYTHON_USEDEP}]
"

src_install() {
	local DOCS="${DOCS} README.rst docs/*.rst"
	distutils-r1_src_install

	DOC_CONTENTS="In order to enable ropemacs support in Emacs, install
		app-emacs/pymacs and add the following line to your ~/.emacs file:
		\\n\\t(pymacs-load \"ropemacs\" \"rope-\")"
	readme.gentoo_create_doc
}
