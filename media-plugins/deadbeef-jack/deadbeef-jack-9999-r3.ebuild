# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="JACK output plugin for DeaDBeeF."
HOMEPAGE="https://github.com/DeaDBeeF-Player/jack"
EGIT_REPO_URI="https://github.com/DeaDBeeF-Player/jack.git"

LICENSE="MIT"
SLOT="0"

DEPEND_COMMON="
	media-sound/deadbeef
	virtual/jack"

RDEPEND="${DEPEND_COMMON}"
DEPEND="${DEPEND_COMMON}"

PATCHES=(
	"${FILESDIR}"/deadbeef-jack-9999-makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	doins jack.so
}
