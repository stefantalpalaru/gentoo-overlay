# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 out-of-source-utils virtualx xdg-utils

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="http://www.pyglet.org/"
SRC_URI="https://github.com/pyglet/pyglet/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples image +sound test"
# pyglet.gl.glx_info.GLXInfoException: pyglet requires an X server with GLX
# Other tests fail or stall for unknown reasons.
RESTRICT="mirror test"

RDEPEND="
	virtual/opengl
	image? ( || (
		dev-python/pillow[${PYTHON_USEDEP}]
		x11-libs/gtk+:2
	) )
	sound? ( || (
		media-libs/libpulse
		media-libs/openal
	) )
	!<dev-python/pyglet-1.4.11-r2[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

DOCS=(
	DESIGN
	NOTICE
	README.md
	RELEASE_NOTES
)

python_test() {
	xdg_environment_reset
	run_in_build_dir virtx pytest -v "${S}"/tests
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
