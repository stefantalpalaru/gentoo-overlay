# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A very small text templating language"
HOMEPAGE="https://pypi.org/project/scripttest/
	https://github.com/pypa/scripttest"
# pypi tarball lacks tests
SRC_URI="https://github.com/pypa/scripttest/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv sparc x86 ~x64-macos"
RESTRICT="mirror test"
