# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A simple pythonic tool for remote execution and deployment"
HOMEPAGE="https://www.fabfile.org
		https://pypi.org/project/fabric/
		https://github.com/fabric/fabric"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc fab2"
# Depends on pytest-relaxed which is not in tree
RESTRICT="mirror test"

RDEPEND="
	!fab2? ( !dev-python/fabric:0 )
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/invoke-1.3[${PYTHON_USEDEP}]
	<dev-python/invoke-2[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.4[${PYTHON_USEDEP}]
	!<dev-python/fabric-2.5.0-r1[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i \
		-e 's/binary_name = "fab"/binary_name = "fab_py2"/' \
		-e 's/binary_name = "fab2"/binary_name = "fab2_py2"/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	if use fab2; then
		export PACKAGE_AS_FABRIC2=1
		ln -s fabric fabric2 || die "symlink create failed"
	fi
	distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c sites/docs/ sites/docs/ sites/docs/html \
		|| die "building docs failed"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( sites/docs/html/. )
	distutils-r1_python_install_all
}
