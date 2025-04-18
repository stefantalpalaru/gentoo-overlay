# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

MY_PN="Cycler"

DESCRIPTION="Composable style cycles"
HOMEPAGE="
	https://matplotlib.org/cycler/
	https://pypi.org/project/Cycler/
	https://github.com/matplotlib/cycler"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="test"
# Not shipped
# https://github.com/matplotlib/cycler/issues/21
RESTRICT="mirror test"

RDEPEND="dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/cycler-0.10.0-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests --verbosity=3 || die
}
