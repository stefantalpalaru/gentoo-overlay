# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Easy, clean, reliable Python 2/3 compatibility"
HOMEPAGE="https://python-future.org/
		https://github.com/PythonCharmers/python-future"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	!<dev-python/future-0.18.2-r3[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx-bootstrap-theme

PATCHES=(
	"${FILESDIR}"/${P}-tests.patch
)

python_prepare_all() {
	# tests requiring network access
	rm tests/test_future/test_requests.py || die
	sed -i -e 's:test.*request_http:_&:' \
		tests/test_future/test_standard_library.py || die

	sed -i \
		-e "s/'futurize = libfuturize.main:main'/'futurize_py2 = libfuturize.main:main'/" \
		-e "s/'pasteurize = libpasteurize.main:main'/'pasteurize_py2 = libpasteurize.main:main'/" \
		setup.py || die

	distutils-r1_python_prepare_all
}
