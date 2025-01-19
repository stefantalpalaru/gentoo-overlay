# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
LUA_REQ_USE="lua52compat"

WX_GTK_VER=3.2-gtk3
PLOCALES="ar be bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS sr_RS@latin tr uk_UA vi zh_CN zh_TW"

inherit flag-o-matic lua-single meson plocale wxwidgets xdg-utils vcs-snapshot toolchain-funcs

DESCRIPTION="Advanced subtitle editor"
HOMEPAGE="http://www.aegisub.org/
	https://github.com/TypesettingTools/Aegisub"
SRC_URI="https://github.com/TypesettingTools/Aegisub/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa debug +fftw openal portaudio pulseaudio spell test +uchardet"
RESTRICT="!test? ( test )"

# aegisub bundles luabins (https://github.com/agladysh/luabins).
# Unfortunately, luabins upstream is practically dead since 2010.
# Thus unbundling luabins isn't worth the effort.
RDEPEND="${LUA_DEPS}
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,debug?]
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	media-libs/ffmpegsource:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libass:=[fontconfig]
	sys-libs/zlib
	virtual/libiconv
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	fftw? ( >=sci-libs/fftw-3.3:= )
	openal? ( media-libs/openal )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-libs/libpulse )
	spell? ( app-text/hunspell:= )
	uchardet? ( app-i18n/uchardet )
"
DEPEND="${RDEPEND}"
# luarocks is only used as a command-line tool so there is no need to enforce
# LUA_SINGLE_USEDEP on it. On the other hand, this means we must use version
# bounds in order to make sure we use a version migrated to Lua eclasses.
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		${RDEPEND}
		>=dev-cpp/gtest-1.8.1
		>=dev-lua/luarocks-3.4.0-r100
		$(lua_gen_cond_dep '
			dev-lua/busted[${LUA_USEDEP}]
		')
	)
"

REQUIRED_USE="${LUA_REQUIRED_USE}
	|| ( alsa openal portaudio pulseaudio )"

PATCHES=(
	"${FILESDIR}"/aegisub-3.4.2-gtest.patch
)

aegisub_check_compiler() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++20; then
		die "Your compiler lacks C++20 support."
	fi
}

pkg_pretend() {
	aegisub_check_compiler
}

pkg_setup() {
	aegisub_check_compiler
	lua-single_pkg_setup
}

src_prepare() {
	default

	plocale_find_changes po '' '.po'
	rm_locale() {
		rm -f po/${1}.po
		sed -e "/^${1}/d" -i po/LINGUAS
	}
	plocale_for_each_disabled_locale rm_locale

	filter-lto

	mkdir "${WORKDIR}/${P}-build"
	cat <<-EOF > "${WORKDIR}/${P}-build"/git_version.h || die
	#define BUILD_GIT_VERSION_NUMBER 0
	#define BUILD_GIT_VERSION_STRING "${PV}"
	#define TAGGED_RELEASE 1
	#define INSTALLER_VERSION "${PV}"
	#define RESOURCE_BASE_VERSION $(ver_rs 1-3 ', ')
	EOF
}

src_configure() {
	tc-export PKG_CONFIG
	# Prevent access violations from OpenAL detection. See Gentoo bug 508184.
	use openal && export agi_cv_with_openal="yes"

	setup-wxwidgets

	# Upstream only supports PCH builds, by leaving out many header includes.
	# Most of them will cause errors during compilation, when PCH is disabled,
	# but others - like "acconf.h" - will silently fail, resulting in a build
	# that assumes FFMS2 and other optional deps are disabled.
	local emesonargs=(
		-Db_pch=true
		-Denable_update_checker=false
		-Dffms2=enabled
		-Dsystem_luajit=true
		$(meson_use debug)
		$(meson_use test tests)
		$(meson_feature alsa)
		$(meson_feature fftw fftw3)
		$(meson_feature openal)
		$(meson_feature portaudio)
		$(meson_feature pulseaudio libpulse)
		$(meson_feature spell hunspell)
		$(meson_feature uchardet)
	)
	export FORCE_GIT_VERSION="v${PV}"
	meson_src_configure
}

src_test() {
	meson_src_test --verbose "gtest main"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
