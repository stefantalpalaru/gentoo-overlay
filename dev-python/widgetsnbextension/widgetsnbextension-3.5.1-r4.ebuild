# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 python3_{10..12} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 pypi

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="http://ipython.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/notebook:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/notebook:0[${PYTHON_USEDEP}]' -3)
"
DEPEND="${RDEPEND}"
