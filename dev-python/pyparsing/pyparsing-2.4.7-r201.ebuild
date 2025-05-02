# Copyright 2004-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

MY_P=${P/-/_}
DESCRIPTION="Easy-to-use Python module for text parsing"
HOMEPAGE="https://github.com/pyparsing/pyparsing
		https://pypi.org/project/pyparsing/"
# pypi releases and generated github tarballs lack tests
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${PN}-${MY_P}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/pyparsing-2.4.7-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py

python_install_all() {
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
