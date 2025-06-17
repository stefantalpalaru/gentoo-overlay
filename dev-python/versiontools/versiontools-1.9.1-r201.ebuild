# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Smart replacement for plain tuple used in __version__"
HOMEPAGE="https://pypi.org/project/versiontools/ https://launchpad.net/versiontools"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/versiontools-1.9.1-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Expexted failure
	sed -e s':test_cant_import:_&:' -i versiontools/tests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
