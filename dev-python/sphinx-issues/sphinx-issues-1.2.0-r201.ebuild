# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Sphinx extension for linking to your project's issue tracker "
HOMEPAGE="https://github.com/sloria/sphinx-issues"
SRC_URI="https://github.com/sloria/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]
	!<dev-python/sphinx-issues-1.2.0-r200[${PYTHON_USEDEP}]
"
