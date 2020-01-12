# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/redis/hiredis-py"
SRC_URI="https://github.com/redis/hiredis-py/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND=">=dev-libs/hiredis-0.14.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/hiredis-py-${PV}"

PATCHES=(
	"${FILESDIR}"/hiredis-0.3.0-system-libs.patch
	"${FILESDIR}"/hiredis-0.14.0.patch
)

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	distutils-r1_python_compile
}
