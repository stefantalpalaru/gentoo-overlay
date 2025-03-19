# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1 pypi

DESCRIPTION="Python library to work with countries and languages"
HOMEPAGE="https://github.com/Diaoul/babelfish
		https://pypi.org/project/babelfish/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

DEPEND="
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	!<dev-python/babelfish-0.5.5-r4[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
