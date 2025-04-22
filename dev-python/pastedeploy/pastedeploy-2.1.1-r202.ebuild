# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="https://pypi.org/project/PasteDeploy/"
# pypi tarball does not include tests
SRC_URI="https://github.com/Pylons/${PN}/archive/${PV}.tar.gz ->  ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/pastedeploy-2.1.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

python_prepare_all() {
	sed -i 's:"pytest-runner"::' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	use doc && dodoc docs/*.txt
	find "${D}" -name '*.pth' -delete || die
}
