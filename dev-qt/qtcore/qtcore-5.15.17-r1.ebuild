# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86"
fi

QT5_MODULE="qtbase"
inherit linux-info flag-o-matic toolchain-funcs qt5-build

DESCRIPTION="Cross-platform application development framework"
SLOT=5/${QT5_PV}
IUSE="icu old-kernel"
RESTRICT="mirror" # https://bugs.gentoo.org/958499

DEPEND="
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libpcre2[pcre16,unicode]
	sys-libs/zlib:=
	icu? ( dev-libs/icu:= )
	!icu? ( virtual/libiconv )
"
RDEPEND="${DEPEND}
	!<dev-qt/designer-${QT5_PV}:5
	!<dev-qt/qt3d-${QT5_PV}:5
	!<dev-qt/qtbluetooth-${QT5_PV}:5
	!<dev-qt/qtcharts-${QT5_PV}:5
	!<dev-qt/qtconcurrent-${QT5_PV}:5
	!<dev-qt/qtdatavis3d-${QT5_PV}:5
	!<dev-qt/qtdbus-${QT5_PV}:5
	!<dev-qt/qtdeclarative-${QT5_PV}:5
	!<dev-qt/qtgamepad-${QT5_PV}:5
	!<dev-qt/qtgraphicaleffects-${QT5_PV}:5
	!<dev-qt/qtgui-${QT5_PV}:5
	!<dev-qt/qthelp-${QT5_PV}:5
	!<dev-qt/qtimageformats-${QT5_PV}:5
	!<dev-qt/qtlocation-${QT5_PV}:5
	!<dev-qt/qtmultimedia-${QT5_PV}:5
	!<dev-qt/qtnetwork-${QT5_PV}:5
	!<dev-qt/qtnetworkauth-${QT5_PV}:5
	!<dev-qt/qtopengl-${QT5_PV}:5
	!<dev-qt/qtpositioning-${QT5_PV}:5
	!<dev-qt/qtprintsupport-${QT5_PV}:5
	!<dev-qt/qtquickcontrols-${QT5_PV}:5
	!<dev-qt/qtquickcontrols2-${QT5_PV}:5
	!<dev-qt/qtquicktimeline-${QT5_PV}:5
	!<dev-qt/qtscript-${QT5_PV}:5
	!<dev-qt/qtscxml-${QT5_PV}:5
	!<dev-qt/qtsensors-${QT5_PV}:5
	!<dev-qt/qtserialbus-${QT5_PV}:5
	!<dev-qt/qtserialport-${QT5_PV}:5
	!<dev-qt/qtspeech-${QT5_PV}:5
	!<dev-qt/qtsql-${QT5_PV}:5
	!<dev-qt/qtsvg-${QT5_PV}:5
	!<dev-qt/qttest-${QT5_PV}:5
	!<dev-qt/qtvirtualkeyboard-${QT5_PV}:5
	!<dev-qt/qtwayland-${QT5_PV}:5
	!<dev-qt/qtwebchannel-${QT5_PV}:5
	!<dev-qt/qtwebengine-${QT5_PV}:5
	!<dev-qt/qtwebsockets-${QT5_PV}:5
	!<dev-qt/qtwebview-${QT5_PV}:5
	!<dev-qt/qtwidgets-${QT5_PV}:5
	!<dev-qt/qtx11extras-${QT5_PV}:5
	!<dev-qt/qtxml-${QT5_PV}:5
	!<dev-qt/qtxmlpatterns-${QT5_PV}:5
"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/corelib
	src/tools/qlalr
	doc
)

QT5_GENTOO_PRIVATE_CONFIG=(
	!:network
	!:sql
	!:testlib
	!:xml
)

pkg_pretend() {
	use kernel_linux || return
	get_running_version
	if kernel_is -lt 4 11 && ! use old-kernel; then
		ewarn "The running kernel is older than 4.11. USE=old-kernel is needed for"
		ewarn "dev-qt/qtcore to function on this kernel properly. Bugs #669994, #672856"
	fi
}

src_prepare() {
	# don't add -O3 to CXXFLAGS, bug 549140
	sed -i -e '/CONFIG\s*+=/s/optimize_full//' src/corelib/corelib.pro || die

	# fix missing qt_version_tag symbol w/ LTO, bug 674382
	sed -i -e 's/^gcc:ltcg/gcc/' src/corelib/global/global.pri || die

	# Broken with FORTIFY_SOURCE=3
	#
	# Our toolchain sets F_S=2 by default w/ >= -O2, so we need
	# to unset F_S first, then explicitly set 2, to negate any default
	# and anything set by the user if they're choosing 3 (or if they've
	# modified GCC to set 3).
	#
	# Refs:
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105078
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105709
	# https://bugreports.qt.io/browse/QTBUG-103782
	# bug #847145
	if tc-enables-fortify-source ; then
		# We can't unconditionally do this b/c we fortify needs
		# some level of optimisation.
		filter-flags -D_FORTIFY_SOURCE=3
		# (Qt doesn't seem to respect CPPFLAGS?)
		append-flags -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
	fi

	qt5-build_src_prepare

	# workaround for a79a370c (...Annotate-QMutex-...patch) adding a header
	qt5_syncqt_version
}

src_configure() {
	local myconf=(
		$(qt_use icu)
		$(qt_use !icu iconv)
	)
	use old-kernel && myconf+=(
		-no-feature-renameat2 # needs Linux 3.16, bug 669994
		-no-feature-getentropy # needs Linux 3.17, bug 669994
		-no-feature-statx # needs Linux 4.11, bug 672856
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path qmake 5

	local flags=(
		DBUS FREETYPE IMAGEFORMAT_JPEG IMAGEFORMAT_PNG
		OPENGL OPENSSL SSL WIDGETS
	)

	for flag in ${flags[@]}; do
		cat >> "${D}"/${QT5_HEADERDIR}/QtCore/qconfig.h <<- _EOF_ || die

			#if defined(QT_NO_${flag}) && defined(QT_${flag})
			# undef QT_NO_${flag}
			#elif !defined(QT_NO_${flag}) && !defined(QT_${flag})
			# define QT_NO_${flag}
			#endif
		_EOF_
	done
}
