# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="chat client using Whisper on the devp2p wire protocol"
HOMEPAGE="https://status.im/"
SRC_URI=""

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	sys-fs/fuse
	sys-libs/zlib
	|| ( gnome-base/libgnome-keyring kde-frameworks/kwallet )
"
BDEPEND="net-misc/curl"

archive_url=""
archive_file=""

src_unpack() {
	# Portage makes it really hard to have an unpredictable SRC_URI
	archive_url="$(curl -s "https://status.im/nightly/" | grep 'href=.*\.AppImage' | tail -n 1 | sed 's/^.*"\([^"]\+\.AppImage\).*$/\1/')"
	if [ -z "${archive_url}" ]; then
		die "empty archive URL"
	fi
	if [[ "${archive_url}" != http*.AppImage ]]; then
		die "URL extraction failed"
	fi
	archive_file="${archive_url##*/}"
	mkdir -p "${S}"
	curl -s -C - -o "${S}/${archive_file}" "${archive_url}" || die "fetch failed"
}

src_install() {
	exeinto "/opt/${PN}/bin"
	newexe "${archive_file}" "status-bin"
	dosym ../../opt/${PN}/bin/status-bin /usr/bin/status-bin
}
