# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="A built-package format for Python"
HOMEPAGE="https://pypi.org/project/wheel/
		https://github.com/pypa/wheel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/pypa/wheel/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"
RESTRICT="test"

RDEPEND="
	!<dev-python/wheel-0.35.1-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	sed \
		-e 's:--cov=wheel::g' \
		-e 's/wheel = wheel.cli:main/wheel_py2 = wheel.cli:main/' \
		-i setup.cfg || die
	distutils-r1_src_prepare
}
