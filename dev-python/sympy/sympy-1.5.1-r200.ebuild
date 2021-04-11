# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="https://sympy.org
		https://github.com/sympy/sympy"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples imaging ipython latex mathml opengl pdf png pyglet symengine test theano"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"
# All tests actually pass, except a bunch of tests related to the deprecated pygletplot
# It is a non-trivial work to wipe out all such tests :-(

RDEPEND="dev-python/mpmath:python2[${PYTHON_USEDEP}]
	dev-python/pexpect:python2[${PYTHON_USEDEP}]
	imaging? ( dev-python/pillow:python2[${PYTHON_USEDEP}] )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl )
	)
	mathml? ( dev-libs/libxml2:2[${PYTHON_USEDEP}] )
	opengl? ( dev-python/pyopengl:python2[${PYTHON_USEDEP}] )
	pyglet? ( dev-python/pyglet:python2[${PYTHON_USEDEP}] )
	symengine? ( dev-python/symengine:python2[${PYTHON_USEDEP}] )
	theano? ( dev-python/theano:python2[${PYTHON_USEDEP}] )
	!<dev-python/sympy-1.5.1-r200[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	test? ( ${RDEPEND} dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${PN}-${P}"

python_prepare_all() {
	sed -i \
		-e "s/'isympy = isympy:main'/'isympy_py2 = isympy:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	virtx "${PYTHON}" setup.py test
}

python_install_all() {
	local DOCS=( AUTHORS README.rst )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
	rm -rf "${ED}/usr/share/man"
}
