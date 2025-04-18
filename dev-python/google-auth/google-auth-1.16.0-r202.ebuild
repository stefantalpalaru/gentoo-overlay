# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Google Authentication Library"
HOMEPAGE="https://github.com/GoogleCloudPlatform/google-auth-library-python
		https://pypi.org/project/google-auth/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

RDEPEND="
	>=dev-python/pyasn1-0.1.7:python2[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/rsa-3.1.4:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0:python2[${PYTHON_USEDEP}]
	>=dev-python/cachetools-2.0.0:python2[${PYTHON_USEDEP}]
	!<dev-python/google-auth-1.16.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	# delete stray files included in the tarball
	find "${S}"/tests -name '*.pyc' -delete || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
