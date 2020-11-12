# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="tk?"
PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1 virtualx

MY_PN="PyOpenGL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="http://pyopengl.sourceforge.net/
		https://pypi.org/project/PyOpenGL/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
#	mirror://sourceforge/pyopengl/${MY_P}.tar.gz" # broken mirror for this release
LICENSE="BSD"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test tk"

RDEPEND="
	media-libs/freeglut
	virtual/opengl
	x11-libs/libXi
	x11-libs/libXmu
	tk? ( dev-tcltk/togl )
"
DEPEND="
	${RDEPEND}
"

# The tests need an X server with the GLX extension. Software rendering
# under Xvfb works but only with llvmpipe, not softpipe or swr.
BDEPEND="
	test? (
		$(python_gen_cond_dep 'dev-python/numpy-python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' -3)
		dev-python/pygame[${PYTHON_USEDEP},opengl,X]
		dev-python/pytest[${PYTHON_USEDEP}]
		!prefix? (
			media-libs/mesa[llvm]
			x11-base/xorg-server[-minimal,xorg]
		)
	)
"

S="${WORKDIR}/${MY_P}"

python_test() {
	run_in_build_dir virtx pytest -vv "${S}"/tests
}