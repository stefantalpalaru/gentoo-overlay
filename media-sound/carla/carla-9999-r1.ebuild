# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-single-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/falkTX/Carla.git"
	EGIT_SUBMODULES=() # Prevent Carla-Plugins from installing
else
	SRC_URI="https://github.com/falkTX/Carla/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	MY_PN="Carla"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Fully-featured audio plugin host, supports many audio drivers and plugin formats"
HOMEPAGE="https://kx.studio/Applications:Carla"
LICENSE="GPL-2 LGPL-3"
SLOT="0"
IUSE="alsa gtk gtk2 opengl osc pulseaudio rdf sf2 sndfile X"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pyqt5[gui,opengl?,svg,widgets,${PYTHON_USEDEP}]')
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:3 )
	gtk2? ( x11-libs/gtk+:2 )
	osc? (
		media-libs/liblo
		media-libs/pyliblo
	)
	pulseaudio? ( media-libs/libpulse )
	rdf? ( dev-python/rdflib )
	sf2? ( media-sound/fluidsynth )
	sndfile? ( media-libs/libsndfile )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s|exec \$PYTHON|exec ${PYTHON}|" \
		data/carla \
		data/carla-control \
		data/carla-database \
		data/carla-jack-multi \
		data/carla-jack-single \
		data/carla-patchbay \
		data/carla-rack \
		data/carla-settings || die "sed failed"
	sed -i "s;/share/appdata;/share/metainfo;g" "${S}/Makefile" || die "sed failed"
	default
}

src_compile() {
	myemakeargs=(
		LIBDIR="/usr/$(get_libdir)"
		SKIP_STRIPPING=true
		HAVE_FFMPEG=false
		HAVE_ZYN_DEPS=false
		HAVE_ZYN_UI_DEPS=false
		HAVE_QT4=false
		HAVE_QT5=true
		HAVE_PYQT5=true
		DEFAULT_QT=5
		HAVE_ALSA=$(usex alsa true false)
		HAVE_FLUIDSYNTH=$(usex sf2 true false)
		HAVE_GTK2=$(usex gtk2 true false)
		HAVE_GTK3=$(usex gtk true false)
		HAVE_LIBLO=$(usex osc true false)
		HAVE_PULSEAUDIO=$(usex pulseaudio true false)
		HAVE_SNDFILE=$(usex sndfile true false)
		HAVE_X11=$(usex X true false)
	)

	# Print which options are enabled/disabled
	make features PREFIX="/usr" "${myemakeargs[@]}"

	emake PREFIX="/usr" "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" "${myemakeargs[@]}" install
	if ! use osc; then
		find "${D}/usr" -iname "carla-control*" | xargs rm
	fi
}
