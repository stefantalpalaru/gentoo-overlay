# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="https://github.com/jelmer/dulwich/
		https://pypi.org/project/dulwich/"
LICENSE="GPL-2+"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm arm64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/certifi:python2[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.23:python2[${PYTHON_USEDEP}]
	!<dev-python/dulwich-0.19.15-r4[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		!hppa? (
			dev-python/gevent[${PYTHON_USEDEP}]
			dev-python/geventhttpclient[${PYTHON_USEDEP}]
		)
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/fastimport[${PYTHON_USEDEP}]
	)"

DISTUTILS_IN_SOURCE_BUILD=1

# One test sometimes fails
# https://github.com/jelmer/dulwich/issues/541
PATCHES=( "${FILESDIR}/${PN}-0.18.3-skip-failing-test.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# Do not use make check which rebuilds the extension and uses -Werror,
	# causing unexpected failures.
	"${EPYTHON}" -m unittest -v dulwich.tests.test_suite \
		|| die "tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
	for F in "${D}"/usr/bin/*; do
		mv "${F}" "${F}_py2"
	done
	for F in "${D}"/usr/lib/python-exec/python2.7/*; do
		mv "${F}" "${F}_py2"
	done
}
