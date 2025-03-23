# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Namespace for backported Python features"
HOMEPAGE="https://pypi.org/project/backports/"
SRC_URI="https://dev.gentoo.org/~radhermit/dist/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="!<dev-python/backports-lzma-0.0.2-r1"
