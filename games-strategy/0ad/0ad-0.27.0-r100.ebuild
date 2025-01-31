# Copyright 2014-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
MY_P="0ad-${PV/_/-}"

inherit desktop toolchain-funcs multiprocessing wxwidgets xdg

DESCRIPTION="A free, real-time strategy game"
HOMEPAGE="https://play0ad.com/"
SRC_URI="
	http://releases.wildfiregames.com/${MY_P}-unix-build.tar.xz
	https://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz
"
S="${WORKDIR}/${MY_P}"
LICENSE="BitstreamVera CC-BY-SA-3.0 GPL-2 LGPL-2.1 LPPL-1.3c MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="editor +lobby lto nvtt pch test vulkan"

RESTRICT="test"
CHECKREQS_DISK_BUILD="5000M" # for alpha 27
CHECKREQS_DISK_USR="3500M" # 3555340 KiB (3.3 GiB)

# Premake adds '-s' to some LDFLAGS. Simply sed'ing it out leads to
# build and/or startup issues.
QA_PRESTRIPPED="/usr/lib64/0ad/libCollada.so /usr/lib64/0ad/libAtlasUI.so /usr/bin/0ad /usr/bin/0ad-ActorEditor"

BDEPEND="
	>=dev-util/premake-5.0.0_alpha12:5
	virtual/pkgconfig
	test? ( dev-lang/perl )
"

# Removed dependency on nvtt as we use the bundled one.
# bug #768930
DEPEND="
	dev-lang/spidermonkey:115=
	dev-libs/boost:=
	dev-libs/icu:=
	dev-libs/libfmt:0=
	dev-libs/libsodium:=
	dev-libs/libxml2
	media-libs/libpng:0
	media-libs/libsdl2[X,opengl,video,vulkan?]
	media-libs/libvorbis
	media-libs/openal
	net-libs/enet:1.3
	net-libs/miniupnpc:=
	net-misc/curl
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	lobby? ( net-libs/gloox )
"
RDEPEND="
	${DEPEND}
	!games-strategy/0ad-data
"

pkg_setup() {
	use editor && setup-wxwidgets
}

src_prepare() {
	default

	# Originally from 0ad-data
	rm binaries/data/tools/fontbuilder/fonts/*.txt || die
}

src_configure() {
	# 0AD uses premake:5 to generate the Makefiles, so let's
	# 1. configure the configure args,
	# 2. export some toolchain args,
	# 3. configure premake args,
	# 4. run premake5.
	local myconf=(
		--minimal-flags
		--with-system-mozjs
		$(usex editor "" "--without-atlas")
		$(usex lobby "" "--without-lobby")
		$(usex lto "--with-lto" "")
		$(usex nvtt "" "--without-nvtt")
		$(usex pch "" "--without-pch")
		$(usex test "" "--without-tests")
		--bindir="/usr/bin"
		--libdir="/usr/$(get_libdir)"/${PN}
		--datadir="/usr/share/${PN}"
	)

	tc-export AR CC CXX RANLIB

	local mypremakeargs=(
		--file="premake5.lua"
		--outpath="../workspace/gcc"
		--os=linux
		--verbose
	)

	cd "${S}/build/premake" || die "Could not enter premake directory"

	premake5 "${mypremakeargs[@]}" "${myconf[@]}" gmake2 \
		|| die "Premake failed"
}

src_compile() {
	# Build 3rd party libs
	einfo "Building bundled libraries"
	pushd libraries
	./build-source-libs.sh -j$(makeopts_jobs) --with-system-mozjs || die
	popd

	# Build 0ad itself!
	einfo "Building 0ad"
	JOBS="-j$(makeopts_jobs)" emake -C build/workspace/gcc verbose=1
}

src_test() {
	cd binaries/system || die
	./test -libdir "${S}/binaries/system" || die "Failed tests"
}

src_install() {
	newbin binaries/system/pyrogenesis 0ad
	use editor && newbin binaries/system/ActorEditor 0ad-ActorEditor

	# Merged from 0ad-data
	# bug #771147 (comment 3)
	insinto /usr/share/${PN}
	doins -r binaries/data/{l10n,config,mods,tools}

	# Install bundled libs
	# bug #771147 (comment 1)
	exeinto /usr/$(get_libdir)/${PN}
	doexe binaries/system/libCollada.so

	use nvtt && doexe binaries/system/{libnvtt,libnvcore,libnvimage,libnvmath}.so
	use editor && doexe binaries/system/libAtlasUI.so

	dodoc binaries/system/readme.txt
	doicon -s 128 build/resources/${PN}.png
	make_desktop_entry ${PN}
}
