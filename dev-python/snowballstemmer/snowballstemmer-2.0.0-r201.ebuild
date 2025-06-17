# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Stemmer algorithms generated from Snowball algorithms"
HOMEPAGE="https://snowballstem.org/
	https://github.com/snowballstem/snowball
	https://pypi.org/project/snowballstemmer/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~x64-solaris"
RESTRICT="mirror"
