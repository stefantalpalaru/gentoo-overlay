# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python language bindings for OpenStack Clouds"
HOMEPAGE="https://github.com/rackspace/pyrax"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="mirror !test? ( test )"

CDEPEND="
	dev-python/keyring:python2[${PYTHON_USEDEP}]
	dev-python/mock:python2[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.13.0:python2[${PYTHON_USEDEP}]
	dev-python/rackspace-novaclient:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0:python2[${PYTHON_USEDEP}]
	!<dev-python/pyrax-1.9.7-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/rax-scheduled-images-python-novaclient-ext[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_test() {
	nosetests tests/unit || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( samples/. )

	distutils-r1_python_install_all
}
