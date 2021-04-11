# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="A parallel Python test runner built around subunit"
HOMEPAGE="https://github.com/mtreinish/stestr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 arm64 hppa ~mips ~ppc64 s390 x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/subunit-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.8.9[${PYTHON_USEDEP}]
	!<dev-python/stestr-2.6.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/stestr = stestr.cli:main/stestr_py2 = stestr.cli:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
