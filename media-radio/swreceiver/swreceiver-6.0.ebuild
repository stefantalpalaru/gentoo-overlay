# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="SDR-J SW receiver for RTL2832-based USB sticks"
HOMEPAGE="http://www.sdr-j.tk/"
SRC_URI="http://www.sdr-j.tk/sdr-j-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4
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

S="${WORKDIR}/sdr-j-${P}"
INPUT_DIRS="cardreader dabstick filereader pmsdr"

src_prepare() {
	sed -e 's#/usr/include/qwt#/usr/include/qwt6#g' \
		-e 's#-lqwt#-lqwt6-qt4#g' \
		-i ${PN}/*.pro ${PN}/plugins/decoders/*/*.pro
	cd ${PN}
	eqmake4
	cd plugins/input
	for d in $INPUT_DIRS; do
		cd $d
		eqmake4
		cd ..
	done
	cd ../decoders
	for d in *-decoder; do
		cd $d
		nonfatal eqmake4
		cd ..
	done
}

src_compile() {
	cd ${PN}
	qt4-r2_src_compile
	cd plugins/input
	for d in $INPUT_DIRS; do
		cd $d
		qt4-r2_src_compile
		cd ..
	done
	cd ../decoders
	for d in *-decoder; do
		cd $d
		nonfatal qt4-r2_src_compile
		cd ..
	done
}

src_install() {
	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe "linux-bin/sdr-j-swradio-${PV}" "${PN}"
	dodir "/usr/lib/${PN}/input"
	insinto "/usr/lib/${PN}/input"
	doins linux-bin/input-plugins/*.so
	dodir "/usr/lib/${PN}/decoder"
	insinto "/usr/lib/${PN}/decoder"
	doins linux-bin/decoder-plugins/*.so
	elog "Make sure your ~/.jsdr-sw.ini file has 'deviceBase=/usr/lib/${PN}/input' and 'decoderBase=/usr/lib/${PN}/decoder' in it"
	elog "(you'll need to run ${PN} first to create it)"
}
