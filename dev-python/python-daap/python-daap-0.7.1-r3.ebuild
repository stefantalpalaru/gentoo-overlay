# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1
MY_COMMIT="d5659fdfaae99042e6cf8ec8556363fc38569e30"

inherit distutils-r1 flag-o-matic

DESCRIPTION="PyDaap is a DAAP client implemented in Python, based on PyTunes"
HOMEPAGE="https://movieos.org/code/pythondaap/
	https://github.com/tominsam/pythondaap"
SRC_URI="https://github.com/tominsam/PythonDaap/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/PythonDaap-${MY_COMMIT}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
RESTRICT="mirror"

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
