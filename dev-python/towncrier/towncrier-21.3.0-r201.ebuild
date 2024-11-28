# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Building newsfiles for your project"
HOMEPAGE="https://github.com/twisted/towncrier"
SRC_URI="https://github.com/twisted/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-default-group[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	!<dev-python/towncrier-21.3.0-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-vcs/git
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i \
		-e 's/towncrier = towncrier._shell:cli/towncrier_py2 = towncrier._shell:cli/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	trial towncrier || die "tests failed with ${EPYTHON}"
}
