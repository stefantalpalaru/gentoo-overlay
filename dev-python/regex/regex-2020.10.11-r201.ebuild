# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Alternative regular expression module to replace re"
HOMEPAGE="https://bitbucket.org/mrabarnett/mrab-regex"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/regex-2020.10.11-r200[${PYTHON_USEDEP}]
"

python_test() {
	distutils_install_for_testing

	pushd "${BUILD_DIR}/lib" > /dev/null || die
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/Features.html )
	local DOCS=( README.rst docs/*.rst )

	distutils-r1_python_install_all
}
