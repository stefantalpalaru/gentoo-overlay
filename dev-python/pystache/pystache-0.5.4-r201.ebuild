# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Mustache for Python"
HOMEPAGE="https://github.com/defunkt/pystache"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	!<dev-python/pystache-0.5.4-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -i \
		-e 's/pystache=pystache.commands.render:main/pystache_py2=pystache.commands.render:main/' \
		-e 's/pystache-test=pystache.commands.test:main/pystache-test_py2=pystache.commands.test:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	nosetests --verbose || die
}
