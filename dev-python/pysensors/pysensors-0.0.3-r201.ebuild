# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual
PYPI_PN="PySensors"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings to libsensors (via ctypes)"
HOMEPAGE="https://pypi.org/project/PySensors/"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=sys-apps/lm-sensors-3
	!<dev-python/pysensors-0.0.3-r2[${PYTHON_USEDEP}]
"
