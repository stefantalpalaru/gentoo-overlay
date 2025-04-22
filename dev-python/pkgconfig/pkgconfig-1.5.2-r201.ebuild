# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Interface Python with pkg-config"
HOMEPAGE="https://pypi.org/project/pkgconfig/ https://github.com/matze/pkgconfig"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	!<dev-python/pkgconfig-1.5.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	sed -e '/nose/d' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die
}
