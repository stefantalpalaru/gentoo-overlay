# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Simple config file reader and writer"
HOMEPAGE="http://www.voidspace.org.uk/python/configobj.html
			https://pypi.org/project/configobj/
			https://github.com/DiffSK/configobj"
SRC_URI="https://github.com/DiffSK/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/configobj-5.0.6-r4[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-fix-py2-tests.patch" )
