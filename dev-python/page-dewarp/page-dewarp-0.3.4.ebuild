# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Document image dewarping library using a cubic sheet model"
HOMEPAGE="
	https://pypi.org/project/page-dewarp/
	https://github.com/lmmx/page-dewarp
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/matplotlib:0[${PYTHON_USEDEP}]
	dev-python/msgspec[${PYTHON_USEDEP}]
	dev-python/numpy:0[${PYTHON_USEDEP}]
	dev-python/scipy:0[${PYTHON_USEDEP}]
	dev-python/sympy:0[${PYTHON_USEDEP}]
	media-libs/opencv:0[python,${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/inline-snapshot[${PYTHON_USEDEP}]
		dev-python/pytest:0[${PYTHON_USEDEP}]
		media-gfx/czkawka
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
