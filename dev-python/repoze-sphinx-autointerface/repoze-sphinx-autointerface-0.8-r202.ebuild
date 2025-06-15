# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN//-/.}
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension: auto-generates API docs from Zope interfaces"
HOMEPAGE="https://pypi.org/project/repoze.sphinx.autointerface/"
S=${WORKDIR}/${MY_P}
LICENSE="repoze"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="mirror"

RDEPEND="
	dev-python/sphinx:python2[${PYTHON_USEDEP}]
	dev-python/zope-interface:python2[${PYTHON_USEDEP}]
	!<dev-python/repoze-sphinx-autointerface-0.8-r2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

python_install() {
	distutils-r1_python_install

	# install the namespace (it's the only subpackage)
	python_moduleinto repoze.sphinx
	python_domodule repoze/sphinx/__init__.py
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
