# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="Reliable machine-readable Linux distribution information for Python"
HOMEPAGE="https://distro.readthedocs.io/en/latest/
		https://github.com/nir0s/distro"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/distro-1.5.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/'distro = distro:main'/'distro_py2 = distro:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}
