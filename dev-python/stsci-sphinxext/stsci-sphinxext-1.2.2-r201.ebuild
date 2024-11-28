# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Tools and templates to customize Sphinx for STScI projects"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/stsci_python"
SRC_URI="https://github.com/spacetelescope/stsci.sphinxext/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	dev-python/numpydoc:python2[${PYTHON_USEDEP}]
	!<dev-python/stsci-sphinxext-1.2.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/d2to1-0.2.9[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/stsci-distutils-0.3.2[${PYTHON_USEDEP}]"
