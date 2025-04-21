# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A dot-accessible dictionary (a la JavaScript objects)"
HOMEPAGE="https://github.com/Infinidat/munch"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~hppa ~x86"
RESTRICT="mirror test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="
	!<dev-python/munch-2.5.0-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/munch-2.5.0-revert-pbr.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i "s:__version__:'${PV}':" setup.py || die
}
