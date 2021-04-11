# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Amazon Web Services API"
HOMEPAGE="https://github.com/boto/boto https://pypi.org/project/boto/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 arm arm64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/boto-2.49.0-r4[${PYTHON_USEDEP}]
"

# requires Amazon Web Services keys to pass some tests
RESTRICT="test"

python_prepare_all() {
	for F in bin/*; do
		mv "${F}" "${F}_py2"
	done

	sed -i \
		-e 's%"bin/\([^"]*\)%"bin/\1_py2%g' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" tests/test.py -v || die "Tests fail with ${EPYTHON}"
}
