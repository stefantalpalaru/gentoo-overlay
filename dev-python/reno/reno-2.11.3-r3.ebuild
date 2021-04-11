# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Release notes manager, storing release notes in a git repo and building docs"
HOMEPAGE="https://pypi.org/project/reno/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc64 x86"
IUSE=""

BDEPEND=">=dev-python/pbr-1.4[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.15.0[${PYTHON_USEDEP}]
	!<dev-python/reno-2.11.3-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/reno = reno.main:main/reno_py2 = reno.main:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
