# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="http://sphinx-gallery.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="test"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	!<dev-python/sphinx-gallery-0.4.0-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
"
PDEPEND="
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
"

# tests need extra files not distributed

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/bin/copy_sphinxgallery.sh" "${ED}/usr/bin/copy_sphinxgallery_py2.sh"
	mv "${ED}/usr/bin/sphx_glr_python_to_jupyter.py" "${ED}/usr/bin/sphx_glr_python_to_jupyter_py2.py"
	mv "${ED}/usr/lib/python-exec/python2.7/sphx_glr_python_to_jupyter.py" "${ED}/usr/lib/python-exec/python2.7/sphx_glr_python_to_jupyter_py2.py"
}
