# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A library for editing subtitle files"
HOMEPAGE="https://github.com/tkarabela/pysubs2"
SRC_URI="https://github.com/tkarabela/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

distutils_enable_tests pytest
