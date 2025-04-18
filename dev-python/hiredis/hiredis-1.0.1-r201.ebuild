# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/pietern/hiredis-py"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm x86"
RESTRICT="mirror"

DEPEND=">=dev-libs/hiredis-0.14:=
	!<dev-python/hiredis-1.0.1-r200[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-system-libs.patch
	"${FILESDIR}"/${P}-api-0.14.patch
)

src_prepare() {
	default

	append-cflags "-fpermissive"
}

python_test() {
	cd test
	"${EPYTHON}" -m unittest reader.ReaderTest || die "tests failed"
}
