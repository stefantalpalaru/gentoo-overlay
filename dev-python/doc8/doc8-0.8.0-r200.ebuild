# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Style checker for Sphinx (or other) RST documentation"
HOMEPAGE="https://github.com/PyCQA/doc8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""
RESTRICT="test"

CDEPEND=">=dev-python/pbr-1.6:python2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/restructuredtext-lint-0.7[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]
	!<dev-python/doc8-0.8.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^argparse/d' requirements.txt || die
	sed -i \
		-e 's/doc8 = doc8.main:main/doc8_py2 = doc8.main:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
