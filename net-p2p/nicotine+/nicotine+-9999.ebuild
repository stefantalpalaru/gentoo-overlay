# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="gdbm"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3 xdg

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus/nicotine-plus"
EGIT_REPO_URI="https://github.com/Nicotine-Plus/nicotine-plus.git"

LICENSE="GPL-3 LGPL-3"
SLOT="0"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${RDEPEND}"

EPYTEST_IGNORE=(
	"test/integration/test_startup.py"
)

distutils_enable_tests pytest
