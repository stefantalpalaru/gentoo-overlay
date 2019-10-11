# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Musical key detection software (libkeyfinder CLI)"
HOMEPAGE="https://github.com/EvanPurkhiser/keyfinder-cli"
SRC_URI="https://github.com/EvanPurkhiser/keyfinder-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libkeyfinder
	media-video/ffmpeg:0/56.58.58
"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
}
