# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Rolling backport of unittest.mock for all Pythons"
HOMEPAGE="https://github.com/testing-cabal/mock"
SRC_URI="https://github.com/testing-cabal/mock/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror"

RDEPEND="
	dev-python/funcsigs[${PYTHON_USEDEP}]
	>=dev-python/six-1.9:python2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-17.1[${PYTHON_USEDEP}]
	!!<dev-pytohn/mock-3.0.5-r200[${PYTHON_USEDEP}]
"

python_test() {
	# Upstream supports running tests only in their dream pristine
	# environment.  pytest doesn't work at all if mock is already
	# installed.  We can use plain unittest but we have to reinvent
	# test filtering.
	cp -r mock/tests "${BUILD_DIR}"/lib/mock/ || die
	cd "${BUILD_DIR}"/lib || die
	rm mock/tests/*py3* || die

	"${EPYTHON}" -m unittest discover -v || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG.rst README.rst )

	distutils-r1_python_install_all
}
