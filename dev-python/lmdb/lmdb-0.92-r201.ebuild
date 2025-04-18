# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Lightning Database"
HOMEPAGE="https://github.com/dw/py-lmdb/"
LICENSE="OPENLDAP"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="dev-db/lmdb:=
	!<dev-python/lmdb-0.92-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile() {
	LMDB_FORCE_SYSTEM=1 distutils-r1_python_compile
}
