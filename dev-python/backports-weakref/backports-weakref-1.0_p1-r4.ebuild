# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN/-/.}"

inherit distutils-r1 pypi

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV/_p/.post}

DESCRIPTION="Backport of new features in Python's weakref module"
HOMEPAGE="https://github.com/PiDelport/backports.weakref
		https://pypi.org/project/backports.weakref/"
S="${WORKDIR}/${MY_P}"
LICENSE="PSF-2.3"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RDEPEND="dev-python/backports[${PYTHON_USEDEP}]
	!<dev-python/backports-weakref-1.0_p1-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
# Tests require backports.test.support
RESTRICT=" mirror test"

python_prepare_all() {
	sed -e "s|'setuptools_scm'||" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" \
		"${PYTHON:-python}" tests/test_weakref.py || die "tests failed with ${EPYTHON}"
}

python_install() {
	# avoid a collision with dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build
}
