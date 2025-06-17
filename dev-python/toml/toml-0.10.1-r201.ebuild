# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
TOML_TEST_VER="280497fa5f12e43d7233aed0d74e07ca61ef176b"

inherit distutils-r1

DESCRIPTION="Python library for handling TOML files"
HOMEPAGE="https://github.com/uiri/toml"
SRC_URI="https://github.com/uiri/${PN}/archive/${PV}.tar.gz -> ${P}-1.gh.tar.gz
	test? ( https://github.com/BurntSushi/toml-test/archive/${TOML_TEST_VER}.tar.gz -> toml-test-${TOML_TEST_VER}.gh.tar.gz )"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86"
IUSE="test"
RESTRICT="mirror test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND="
	!<dev-python/toml-0.10.1-r200[${PYTHON_USEDEP}]
"

DOCS=( README.rst )
PATCHES=(
	"${FILESDIR}"/toml-0.10.1-skip-numpy.patch
)

python_prepare_all() {
	if use test; then
		mv "${WORKDIR}/toml-test-${TOML_TEST_VER#v}" "${S}/toml-test" || die
	fi

	distutils-r1_python_prepare_all
}
