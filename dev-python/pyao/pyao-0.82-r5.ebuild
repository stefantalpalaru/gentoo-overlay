# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for the libao library"
HOMEPAGE="https://github.com/tynn/PyAO"
SRC_URI="https://github.com/tynn/PyAO/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc -sparc x86"
IUSE=""

DEPEND=">=media-libs/libao-1.0.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-new_api.patch )

python_compile() {
	"${PYTHON}" config_unix.py || die
	distutils-r1_python_compile
}
