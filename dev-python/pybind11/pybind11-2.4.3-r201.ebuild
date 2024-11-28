# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 pypi

DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="https://github.com/pybind/pybind11"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	!<dev-python/pybind11-2.4.3-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/pybind11-2.4.3-stdint.patch
)
