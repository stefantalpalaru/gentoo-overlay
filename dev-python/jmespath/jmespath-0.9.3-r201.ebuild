# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="JSON Matching Expressions"
HOMEPAGE="https://github.com/boto/jmespath
		https://pypi.org/project/jmespath/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
RDEPEND="
	!<dev-python/jmespath-0.9.3-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	mv bin/jp.py bin/jp_py2.py
	sed -i \
		-e 's#bin/jp.py#bin/jp_py2.py#' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die
}
