# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python library for the snappy compression library from Google"
HOMEPAGE="https://pypi.org/project/python-snappy/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=app-arch/snappy-1.0.2:=
	!<dev-python/python-snappy-0.6.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" test_snappy.py -v || die "Tests fail with ${EPYTHON}"
}
