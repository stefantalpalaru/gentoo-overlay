# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Lightweight, framework-agnostic FFI module from Apache TVM"
HOMEPAGE="
	https://github.com/apache/tvm-ffi
	https://pypi.org/project/apache-tvm-ffi/
"
LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/typing-extensions-4.5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/ninja
	>=dev-build/cmake-3.26
	>=dev-python/cython-3.2.8[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-core-0.10[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
	test? (
		dev-python/ml-dtypes[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-xdist )
distutils_enable_tests pytest

# Gentoo's PEP 517 config replaces upstream cmake.args; repeat this option or
# the Cython extension stays disabled and the package cannot import.
# verified 2026-08-10
DISTUTILS_ARGS=(
	-DTVM_FFI_BUILD_PYTHON_MODULE=ON
)
