# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="tk?"
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN=PyOpenGL

inherit distutils-r1 out-of-source-utils pypi virtualx

MY_PN="PyOpenGL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="http://pyopengl.sourceforge.net/
		https://pypi.org/project/PyOpenGL/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test tk"

RDEPEND="
	media-libs/freeglut
	virtual/opengl
	x11-libs/libXi
	x11-libs/libXmu
	tk? ( dev-tcltk/togl )
	!<dev-python/pyopengl-3.1.5-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

# The tests need an X server with the GLX extension. Software rendering
# under Xvfb works but only with llvmpipe, not softpipe or swr.
BDEPEND="
	test? (
		dev-python/numpy-python2[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP},opengl,X]
		dev-python/pytest[${PYTHON_USEDEP}]
		!prefix? (
			media-libs/mesa[llvm]
			x11-base/xorg-server[-minimal,xorg]
		)
	)
"

python_test() {
	run_in_build_dir virtx pytest -vv "${S}"/tests
}
