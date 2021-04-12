# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_COMMIT="d5659fdfaae99042e6cf8ec8556363fc38569e30"

DESCRIPTION="PyDaap is a DAAP client implemented in Python, based on PyTunes"
HOMEPAGE="https://movieos.org/code/pythondaap/
	https://github.com/tominsam/pythondaap"
SRC_URI="https://github.com/tominsam/PythonDaap/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

S="${WORKDIR}/PythonDaap-${MY_COMMIT}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
