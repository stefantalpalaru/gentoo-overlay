# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A py.test plugin to validate Jupyter notebooks"
HOMEPAGE="https://github.com/computationalmodelling/nbval"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/coverage:python2[${PYTHON_USEDEP}]
	dev-python/pytest:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	dev-python/jupyter_client:python2[${PYTHON_USEDEP}]
	dev-python/nbformat:python2[${PYTHON_USEDEP}]
	dev-python/ipykernel:python2[${PYTHON_USEDEP}]
	!<dev-python/nbval-0.9.5-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	)"
