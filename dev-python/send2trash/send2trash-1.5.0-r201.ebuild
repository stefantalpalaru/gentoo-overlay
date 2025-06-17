# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="Send2Trash"
MY_P="${MY_PN}-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Sends files to the Trash (or Recycle Bin)"
HOMEPAGE="
	https://pypi.org/project/Send2Trash/
	https://github.com/hsoft/send2trash"
S="${WORKDIR}"/${MY_P}
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/send2trash-1.5.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-fix-broken-tests-on-py2.patch"
)

python_test() {
	${EPYTHON} setup.py test
}
