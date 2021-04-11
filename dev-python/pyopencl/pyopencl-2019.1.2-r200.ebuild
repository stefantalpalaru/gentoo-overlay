# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="https://mathema.tician.de/software/pyopencl
	https://pypi.org/project/pyopencl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="examples opengl"

RDEPEND="
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4.0:python2[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.2.0:python2[${PYTHON_USEDEP}]
	dev-python/mako:python2[${PYTHON_USEDEP}]
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	dev-python/pybind11:python2[${PYTHON_USEDEP}]
	>=dev-python/pytools-2017.6:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0:python2[${PYTHON_USEDEP}]
	>=virtual/opencl-0-r1
	!<dev-python/pyopencl-2019.1.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_configure() {
	local myconf=()
	if use opengl; then
		myconf+=(--cl-enable-gl)
	fi

	"${PYTHON}" configure.py \
		--boost-compiler=gcc \
		--boost-python-libname=boost_python-${PYTHON_ABI}-mt \
		--no-use-shipped-boost \
		"${myconf[@]}"
}

python_install_all() {
	if use examples; then
		local EXAMPLES=( examples/. )
		einfo "Some of the examples provided by this package require dev-python/matplotlib."
	fi
	distutils-r1_python_install_all
}
