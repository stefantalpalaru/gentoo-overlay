# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic optfeature toolchain-funcs

DESCRIPTION="A Pythonic binding for the libxml2 and libxslt libraries"
HOMEPAGE="https://lxml.de/
		https://pypi.org/project/lxml/
		https://github.com/lxml/lxml"
SRC_URI="https://github.com/lxml/lxml/archive/${P}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/lxml-${P}

LICENSE="BSD ElementTree GPL-2 PSF-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc examples +threads test"
RESTRICT="!test? ( test )"

# Note: lib{xml2,xslt} are used as C libraries, not Python modules.
RDEPEND="
	>=dev-libs/libxml2-2.9.5
	>=dev-libs/libxslt-1.1.28
	!<dev-python/lxml-4.5.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/cssselect[${PYTHON_USEDEP}] )
	"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.0-tests-pypy.patch
)

python_prepare_all() {
	# avoid replacing PYTHONPATH in tests.
	sed -i -e '/sys\.path/d' test.py || die

	# don't use some random SDK on Darwin
	sed -i -e '/_ldflags =/s/=.*isysroot.*darwin.*None/= None/' \
		setupinfo.py || die

	append-cflags -fpermissive

	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	tc-export PKG_CONFIG
	distutils-r1_python_compile
}

python_test() {
	cp -r -l src/lxml/tests "${BUILD_DIR}"/lib/lxml/ || die
	cp -r -l src/lxml/html/tests "${BUILD_DIR}"/lib/lxml/html/ || die
	ln -s "${S}"/doc "${BUILD_DIR}"/ || die

	"${EPYTHON}" test.py -vv --all-levels -p || die "Test ${test} fails with ${EPYTHON}"
}

python_install_all() {
	if use doc; then
		local DOCS=( README.rst *.txt doc/*.txt )
		local HTML_DOCS=( doc/html/. )
	fi
	if use examples; then
		dodoc -r samples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Support for BeautifulSoup as a parser backend" dev-python/beautifulsoup4:python2
	optfeature "Translates CSS selectors to XPath 1.0 expressions" dev-python/cssselect
}
