# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="https://libcloud.apache.org/
		https://github.com/apache/libcloud"
SRC_URI="https://github.com/apache/libcloud/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="examples test"

RDEPEND="
	!<dev-python/libcloud-2.8.3-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
		dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]
	)"

# Known test failures
RESTRICT="test"

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi
	distutils-r1_python_prepare_all
}

src_test() {
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die
	distutils-r1_src_test
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
