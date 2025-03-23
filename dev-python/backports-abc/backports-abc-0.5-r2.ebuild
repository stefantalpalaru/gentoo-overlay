# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="${PN/-/_}"

inherit distutils-r1 pypi

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of Python 3.5's 'collections.abc' module"
HOMEPAGE="https://github.com/cython/backports_abc https://pypi.org/project/backports_abc/"
S=${WORKDIR}/${MY_P}
LICENSE="PSF-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/backports-abc-0.5-r1[${PYTHON_USEDEP}]
"

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" "${PYTHON}" tests.py || die "tests failed with ${EPYTHON}"
}
