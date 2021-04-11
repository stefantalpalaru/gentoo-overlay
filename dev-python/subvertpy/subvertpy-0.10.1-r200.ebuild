# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Alternative Python bindings for Subversion"
HOMEPAGE="
	https://jelmer.uk/code/subvertpy/
	https://pypi.org/project/subvertpy/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="python2"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-vcs/subversion-1.4
	!<dev-python/subvertpy-0.10.1-r1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-libs/apr-util"

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/bin/subvertpy-fast-export" "${ED}/usr/bin/subvertpy-fast-export_py2"
	mv "${ED}/usr/lib/python-exec/python2.7/subvertpy-fast-export" "${ED}/usr/lib/python-exec/python2.7/subvertpy-fast-export_py2"
}

python_test() {
	esetup.py test --args=-v
}
