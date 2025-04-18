# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl(+),xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python client library for Google data APIs"
HOMEPAGE="https://github.com/google/gdata-python-client
		https://pypi.org/project/gdata/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"
RESTRICT="mirror"

python_test() {
	# run_service_tests.py requires interaction (and a valid Google account), so skip it.
	"${PYTHON}" tests/run_data_tests.py -v || die "Test failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( samples/. )
	distutils-r1_python_install_all
}
