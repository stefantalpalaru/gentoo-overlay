# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="http://pygraphviz.github.io/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 ppc x86 ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples test"
RESTRICT="mirror !test? ( test )"

BDEPEND="app-arch/unzip"
# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
RDEPEND="media-gfx/graphviz
	!<dev-python/pygraphviz-1.5-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-lang/swig:0
	test? (
		dev-python/doctest-ignore-unicode[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
)

python_prepare_all() {
	append-cflags -fpermissive
	distutils-r1_python_prepare_all
	swig -python pygraphviz/graphviz.i || die
}

python_test() {
	PYTHONPATH=${PYTHONPATH}:${BUILD_DIR}/lib/pygraphviz \
		nosetests -c setup.cfg -x -v || die
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
