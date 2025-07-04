# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Tools for generating printable PDF documents from any data source"
HOMEPAGE="http://www.reportlab.com/"
SRC_URI+=" http://www.reportlab.com/ftp/fonts/pfbfer-20070710.zip"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-python/pillow:python2[tiff,truetype,jpeg(+),${PYTHON_USEDEP}]
	media-libs/libart_lgpl
	sys-libs/zlib
	!<dev-python/reportlab-3.5.13-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}/${PN}-3.5.13-disable-network-tests.patch"
	"${FILESDIR}/${PN}-3.5.13-pillow-VERSION.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	cd ${P}/src/reportlab/fonts || die
	unpack pfbfer-20070710.zip
}

python_compile_all() {
	use doc && emake -C docs html
}

python_compile() {
	append-cflags -fpermissive
	if ! python_is_python3; then
		append-cflags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_test() {
	pushd tests > /dev/null || die
	"${PYTHON}" runAll.py || die "Testing failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	if use examples ; then
		docinto examples
		dosod -r demos/. tools/pythonpoint/demos
	fi

	distutils-r1_python_install_all
}
