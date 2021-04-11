# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="PyHamcrest"

DESCRIPTION="Hamcrest framework for matcher objects"
HOMEPAGE="https://github.com/hamcrest/PyHamcrest"
SRC_URI="https://github.com/hamcrest/PyHamcrest/archive/V${PV}.tar.gz -> ${MY_PN}-${PV}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	!<dev-python/pyhamcrest-1.10.1-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc \
	dev-python/sphinx_rtd_theme

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
