# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="sphinxcontrib_github_alt"

inherit distutils-r1

DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="https://github.com/jupyter/sphinxcontrib_github_alt"
SRC_URI="https://github.com/jupyter/${MY_PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="amd64 arm64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	!<dev-python/sphinxcontrib-github-alt-1.1-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}"-1.1-setup.py.patch
	"${FILESDIR}/${PN}"-1.0-init.py.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	mv "${WORKDIR}/${MY_PN}-${PV}"/sphinxcontrib_github_alt.py "${WORKDIR}/${MY_PN}-${PV}/${MY_PN}/" || die
}
