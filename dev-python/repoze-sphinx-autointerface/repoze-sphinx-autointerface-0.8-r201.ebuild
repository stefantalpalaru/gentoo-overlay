# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//-/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Sphinx extension: auto-generates API docs from Zope interfaces"
HOMEPAGE="https://pypi.org/project/repoze.sphinx.autointerface/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="repoze"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/sphinx:python2[${PYTHON_USEDEP}]
	dev-python/zope-interface:python2[${PYTHON_USEDEP}]
	!<dev-python/repoze-sphinx-autointerface-0.8-r2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

S=${WORKDIR}/${MY_P}

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
