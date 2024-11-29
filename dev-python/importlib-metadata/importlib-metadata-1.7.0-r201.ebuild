# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Read metadata from Python packages"
HOMEPAGE="https://importlib-metadata.readthedocs.io/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv ~s390 sparc x86"
RESTRICT="test"

RDEPEND="
	dev-python/zipp[${PYTHON_USEDEP}]
	>=dev-python/configparser-3.5[${PYTHON_USEDEP}]
	dev-python/contextlib2[${PYTHON_USEDEP}]
	dev-python/pathlib2[${PYTHON_USEDEP}]
	!<dev-python/importlib-metadata-1.7.0-r3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_sphinx "${PN}/docs" \
	'>=dev-python/rst-linker-1.9'

python_prepare_all() {
	# remove dep on setuptools-scm
	sed -e 's:test_find_local:_&:' \
		-i importlib_metadata/tests/test_integration.py || die

	distutils-r1_python_prepare_all
}
