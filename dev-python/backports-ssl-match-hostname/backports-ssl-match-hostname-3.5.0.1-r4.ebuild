# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
# This is a backport from python3.5+
# Do not add python3.5 or later support here, there's no need for it.
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN=backports.ssl_match_hostname

inherit distutils-r1 pypi

MY_PN=${PN/-/.}
MY_PN=${MY_PN//-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of the ssl.match_hostname function"
HOMEPAGE="https://pypi.org/project/backports.ssl_match_hostname/"
S=${WORKDIR}/${MY_P}
LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"

python_install_all() {
	local DOCS=( backports/ssl_match_hostname/README.txt )
	distutils-r1_python_install_all
}

python_install() {
	# main namespace provided by dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build
}
