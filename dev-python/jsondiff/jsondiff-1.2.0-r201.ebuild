# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Diff JSON and JSON-like structures in Python"
HOMEPAGE="https://github.com/xlwings/jsondiff
		https://pypi.org/project/jsondiff/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
# tests require nose_random
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/jsondiff-1.2.0-r200[${PYTHON_USEDEP}]
"

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
