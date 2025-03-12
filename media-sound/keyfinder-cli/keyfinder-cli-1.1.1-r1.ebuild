# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ffmpeg-compat

DESCRIPTION="Musical key detection software (libkeyfinder CLI)"
HOMEPAGE="https://github.com/EvanPurkhiser/keyfinder-cli"
SRC_URI="https://github.com/EvanPurkhiser/keyfinder-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libkeyfinder
	media-video/ffmpeg-compat:4=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/keyfinder-cli-1.1.1-flags.patch
)

src_configure() {
	ffmpeg_compat_setup 4
	ffmpeg_compat_add_flags

	default
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
}
