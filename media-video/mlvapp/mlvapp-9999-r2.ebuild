# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic desktop git-r3 qmake-utils toolchain-funcs xdg-utils

DESCRIPTION="Magic Lantern Video (MLV) processing suite"
HOMEPAGE="https://github.com/ilia3101/MLV-App"
EGIT_REPO_URI="https://github.com/ilia3101/MLV-App"
LICENSE="GPL-3"
SLOT="0"
IUSE="qt5 +qt6"
REQUIRED_USE="^^ ( qt5 qt6 )"

DEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtmultimedia:6
	)
"
RDEPEND="${DEPEND}
	media-video/ffmpeg
"

PATCHES=(
	"${FILESDIR}/mlvapp-1.15-flags.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	default

	append-cflags -fpermissive
}

src_configure() {
	cd platform/qt

	if use qt5; then
		eqmake5 MLVApp.pro
	fi

	if use qt6; then
		local -a args
		mapfile -t args <<<"$(qt5_get_qmake_args)"
		qmake6 -makefile "${args[@]}" MLVApp.pro || die
	fi
}

src_compile() {
	cd platform/qt

	default
}

src_install() {
	cd platform/qt

	dobin mlvapp
	doicon RetinaIMG/MLVAPP.png
	domenu mlvapp.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
