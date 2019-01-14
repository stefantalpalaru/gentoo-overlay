# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="xml"

inherit distutils-r1 git-r3

DESCRIPTION="Convert MS Office xlsx files to CSV"
HOMEPAGE="https://github.com/dilshod/xlsx2csv/"
EGIT_REPO_URI="https://github.com/dilshod/xlsx2csv"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="dev-lang/perl"

python_compile_all() {
	emake -C man
}

python_install_all() {
	distutils-r1_python_install_all
	doman man/${PN}.1
}
