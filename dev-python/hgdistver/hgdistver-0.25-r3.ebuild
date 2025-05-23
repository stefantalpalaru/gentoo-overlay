# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="utility lib to generate python package version infos from mercurial tags"
HOMEPAGE="https://pypi.org/project/hgdistver/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/mercurial
	)"
RDEPEND="
	!<dev-python/hgdistver-0.25-r2[${PYTHON_USEDEP}]
"

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}
