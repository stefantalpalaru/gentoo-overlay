# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils

DESCRIPTION="ebook reader application"
HOMEPAGE="http://koreader.rocks/"
SRC_URI="https://github.com/koreader/koreader/releases/download/v${PV}/koreader-${PV}-amd64.deb"
S="${WORKDIR}"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${DEPEND}
	media-fonts/droid
	media-fonts/noto
	media-libs/libsdl2
"

RESTRICT="mirror"
QA_PREBUILT="/usr/lib64/koreader/*"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	mv usr/lib usr/lib64 || die

	sed -i \
		-e 's%/lib/%/lib64/%' \
		usr/bin/koreader \
		usr/lib64/koreader/reader.lua || die

	rm usr/lib64/koreader/fonts/*.patch || die

	local path font_file
	for path in usr/lib64/koreader/fonts/droid/*.ttf; do
		font_file=$(basename ${path})
		ln -sfn "../../../../share/fonts/droid/${font_file}" "${path}"
	done
	for path in usr/lib64/koreader/fonts/noto/*.ttf; do
		font_file=$(basename ${path})
		ln -sfn "../../../../share/fonts/noto/${font_file}" "${path}"
	done

	gunzip usr/share/doc/koreader/changelog.Debian.gz
	gunzip usr/share/man/man1/koreader.1.gz
	mv usr/share/doc/koreader usr/share/doc/"${P}"
}

src_install() {
	cp -a * "${ED}/"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
