# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="High performance compressor optimized for binary data"
HOMEPAGE="http://python-blosc.blosc.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="MIT"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/c-blosc:=
	!<dev-python/blosc-1.5.1-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	export BLOSC_DIR="${EPREFIX}/usr"
	distutils-r1_python_prepare_all
	DOCS=( ANNOUNCE.rst  README.rst  RELEASE_NOTES.rst )
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	PYTHONPATH=. nosetests -v || die
}
