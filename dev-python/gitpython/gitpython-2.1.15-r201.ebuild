# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
PYPI_PN="GitPython"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_PN="GitPython"
MY_PV="${PV/_rc/.RC}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Library used to interact with Git repositories"
HOMEPAGE="https://github.com/gitpython-developers/GitPython
		https://pypi.org/project/GitPython/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# Tests only work with the GitPython repo
RESTRICT="test"

RDEPEND="
	dev-vcs/git
	>=dev-python/gitdb2-2.0.0[${PYTHON_USEDEP}]
	!<dev-python/gitpython-2.1.15-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ddt-1.1.1[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"
