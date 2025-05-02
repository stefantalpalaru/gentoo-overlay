# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python library for tor's pluggable transport managed-proxy protocol"
HOMEPAGE="https://gitweb.torproject.org/pluggable-transports/pyptlib.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE="doc examples"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DOCS=( README.rst TODO )

python_test() {
	"${PYTHON}" -m unittest discover || die "tests failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
