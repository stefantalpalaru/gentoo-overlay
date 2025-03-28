# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Library to access any version control system"
HOMEPAGE="https://pypi.org/project/anyvc/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bazaar doc git mercurial subversion"
RESTRICT="mirror"

RDEPEND="dev-python/apipkg[${PYTHON_USEDEP}]
	dev-python/execnet[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	bazaar? ( dev-vcs/bzr )
	git? ( dev-python/dulwich[${PYTHON_USEDEP}] )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( dev-python/subvertpy:python2 )"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/hgdistver[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Do not use unsupported theme options.
	sed -e "/'tagline':/d" \
		-e "/'bitbucket_project':/d" \
		-i docs/conf.py
		distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build -b html docs docs_output || die "Generation of documentation failed"
	fi
}

python_install_all() {
	if use doc; then
		pushd docs_output > /dev/null
		docinto html
		cp -R [a-z]* _static "${ED}/usr/share/doc/${PF}/html" || die "Installation of documentation failed"
		popd > /dev/null
	fi
	distutils-r1_python_install_all
}
