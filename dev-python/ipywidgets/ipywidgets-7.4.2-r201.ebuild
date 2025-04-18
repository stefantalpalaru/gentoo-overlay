# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="https://ipywidgets.readthedocs.io/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/ipykernel-4.5.1:python2[${PYTHON_USEDEP}]
	>=dev-python/nbformat-4.2.0:python2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.1:python2[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-3.4.2[${PYTHON_USEDEP}]
	!<dev-python/ipywidgets-7.4.2-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_test() {
	nosetests ipywidgets || die
}
