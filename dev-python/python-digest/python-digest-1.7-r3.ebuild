# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1 pypi

DESCRIPTION="A Python library to aid in implementing HTTP Digest Authentication"
HOMEPAGE="https://pypi.org/project/python-digest/
		https://bitbucket.org/akoha/python-digest/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"

PATCHES=( "${FILESDIR}"/${P}-unittest.patch )

python_test() {
	"${PYTHON}" ${PN/-/_}/tests.py || die "Tests failed under ${EPYTHON}"
}
