# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Utilities used to package some of STScI's Python projects"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/stsci_python"
SRC_URI="https://github.com/spacetelescope/stsci.distutils/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

DEPEND="
	dev-python/d2to1[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	!<dev-python/stsci-distutils-0.3.8-r200[${PYTHON_USEDEP}]
"
