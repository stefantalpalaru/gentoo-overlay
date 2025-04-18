# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="HTTP request/response parser for python in C"
HOMEPAGE="https://github.com/benoitc/http-parser"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 s390 ~sparc x86"
IUSE="examples"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/http-parser-0.8.3-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"

python_compile() {
	if [[ ${EPYTHON} != python3* ]]; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_install_all() {
	local DOCS=( README.rst )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
