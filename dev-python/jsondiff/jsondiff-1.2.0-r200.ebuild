# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Diff JSON and JSON-like structures in Python"
HOMEPAGE="https://github.com/xlwings/jsondiff
		https://pypi.org/project/jsondiff/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/jsondiff-1.2.0-r200[${PYTHON_USEDEP}]
"

# tests require nose_random
RESTRICT="test"

python_prepare_all() {
	# Avoid file collision with jsonpatch's jsondiff cli.
	sed -i \
		-e "/'jsondiff=jsondiff.cli:main_deprecated'/d" \
		-e "s/'jdiff=jsondiff.cli:main'/'jdiff_py2=jsondiff.cli:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
}
