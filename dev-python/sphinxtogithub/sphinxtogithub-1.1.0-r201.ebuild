# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="preparing the html output of Sphinx documentation for github pages"
HOMEPAGE="https://github.com/michaeljones/sphinx-to-github/"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="amd64 arm x86"
RESTRICT="mirror"

RDEPEND=">=dev-python/sphinx-1.1:python2[${PYTHON_USEDEP}]
	!<dev-python/sphinxtogithub-1.1.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Req'd to avoid file collisions
	sed -e s":find_packages():find_packages(exclude=['tests']):" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
