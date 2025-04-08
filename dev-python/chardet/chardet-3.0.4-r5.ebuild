# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Universal encoding detector"
HOMEPAGE="https://github.com/chardet/chardet
		https://pypi.org/project/chardet/"
SRC_URI="https://github.com/chardet/chardet/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

# SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
# PyPI tarball is missing test.py: https://github.com/chardet/chardet/pull/118

LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	!<dev-python/chardet-3.0.4-r3[${PYTHON_USEDEP}]
"
DEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-pytest-4.patch
)

python_prepare_all() {
	sed -i \
		-e "s/'chardetect = chardet.cli.chardetect:main'/'chardetect_py2 = chardet.cli.chardetect:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}
