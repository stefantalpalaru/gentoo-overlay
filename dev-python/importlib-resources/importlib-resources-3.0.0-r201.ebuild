# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is a backport of Python 3.9's importlib.resources
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="https://importlib-resources.readthedocs.io/en/latest/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
RESTRICT="test"

RDEPEND="
	dev-python/contextlib2[${PYTHON_USEDEP}]
	dev-python/pathlib2[${PYTHON_USEDEP}]
	dev-python/singledispatch[${PYTHON_USEDEP}]
	dev-python/typing[${PYTHON_USEDEP}]
	dev-python/zipp[${PYTHON_USEDEP}]
	!<dev-python/importlib-resources-3.0.0-r3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-3.4.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/rst-linker dev-python/jaraco-packaging

python_compile() {
	distutils-r1_python_compile
	if ! python_is_python3; then
		rm "${BUILD_DIR}/lib/importlib_resources/_py3.py" || die
	fi
}

python_install() {
	distutils-r1_python_install --skip-build
}
