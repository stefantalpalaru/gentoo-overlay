# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Module capable of generating both LANMAN and NT password hashes, for e.g. Samba"
HOMEPAGE="https://barryp.org/software/py-smbpasswd/
	https://github.com/barryp/py-smbpasswd"
SRC_URI="https://github.com/barryp/py-smbpasswd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""
