# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Jupyter protocol implementation and client libraries"
HOMEPAGE="https://jupyter.org
		https://github.com/jupyter/jupyter_client"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	dev-python/traitlets:python2[${PYTHON_USEDEP}]
	dev-python/jupyter_core:python2[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0:python2[${PYTHON_USEDEP}]
	www-servers/tornado:python2[${PYTHON_USEDEP}]
	!<dev-python/jupyter_client-5.3.4-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -i \
		-e 's/jupyter-kernelspec = jupyter_client.kernelspecapp:KernelSpecApp.launch_instance/jupyter-kernelspec_py2 = jupyter_client.kernelspecapp:KernelSpecApp.launch_instance/' \
		-e 's/jupyter-run = jupyter_client.runapp:RunApp.launch_instance/jupyter-run_py2 = jupyter_client.runapp:RunApp.launch_instance/' \
		-e 's/jupyter-kernel = jupyter_client.kernelapp:main/jupyter-kernel_py2 = jupyter_client.kernelapp:main/' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv jupyter_client || die
}
