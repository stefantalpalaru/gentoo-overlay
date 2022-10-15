# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LXQt Build Tools"
HOMEPAGE="https://lxqt-project.org/"
SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~x86"
LICENSE="BSD"
SLOT="0"

DEPEND="
	>=dev-libs/glib-2.73.1
	>=dev-qt/qtcore-5.15:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/lxqt-build-tools-0.11.0-glib-2.73.1.patch"
)
