# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 qmake-utils

DESCRIPTION="SDR-J SW receiver for RTL2832-based USB sticks"
HOMEPAGE="http://www.sdr-j.tk/"
EGIT_REPO_URI="https://github.com/JvanKatwijk/sdr-j-sw"
EGIT_COMMIT="e00f2922f3301a78d6fa6a82bf40104b2a992680"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	virtual/ffmpeg
	virtual/libusb:1
	x11-libs/qwt:6"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/swreceiver"
INPUT_DIRS="cardreader dabstick filereader pmsdr"

src_prepare() {
	default
	sed -e 's#/usr/include/qwt#/usr/include/qwt6#g' \
		-e 's#/usr/include/qt5/qwt#/usr/include/qwt6#g' \
		-e 's#-lqwt#-lqwt6#g' \
		-i *.pro plugins/decoders/*/*.pro
}

src_configure() {
	eqmake5
	cd plugins/input
	for d in $INPUT_DIRS; do
		cd $d
		eqmake5
		cd ..
	done
	cd ../decoders
	for d in *-decoder; do
		cd $d
		nonfatal eqmake5
		cd ..
	done
}

src_compile() {
	default
	cd plugins/input
	for d in $INPUT_DIRS; do
		cd $d
		default
		cd ..
	done
	cd ../decoders
	for d in *-decoder; do
		cd $d
		nonfatal default
		cd ..
	done
}

src_install() {
	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe ../../linux-bin/sdr-j-swreceiver-* "${PN}"
	dodir "/usr/lib/${PN}/input"
	insinto "/usr/lib/${PN}/input"
	doins ../../linux-bin/input-plugins-sw/*.so
	dodir "/usr/lib/${PN}/decoder"
	insinto "/usr/lib/${PN}/decoder"
	doins ../../linux-bin/decoder-plugins/*.so
	elog "Make sure your ~/.jsdr-sw.ini file has 'deviceBase=/usr/lib/${PN}/input' and 'decoderBase=/usr/lib/${PN}/decoder' in it"
	elog "(you'll need to run ${PN} first to create it)"
}
