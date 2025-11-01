# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Free Music Instrument Tuner"
HOMEPAGE="https://gillesdegottex.github.io/fmit"
SRC_URI="https://github.com/gillesdegottex/fmit/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack oss portaudio"

RDEPEND=">=sci-libs/fftw-3.3.4:3.0=
	dev-qt/qtbase:6[gui,opengl,widgets]
	dev-qt/qtsvg:6
	dev-qt/qtmultimedia:6
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	portaudio? ( media-libs/portaudio )"

DEPEND="${RDEPEND}"

src_prepare() {
	# Fix the path to readme file to prevent errors on start up
	sed -i "/QFile readmefile/c\QFile readmefile \
		(\"/usr/share/doc/${PF}/README.txt\");" \
		src/main.cpp || die "README sed failed"
	# Fix the PREFIX location, insert real path.
	sed -i "/QString fmitprefix/c\QString fmitprefix(STR(/usr));" \
		src/main.cpp || die "PREFIX fix sed failed"
	# Fix the PREFIX location, insert real path.
	sed -i "/QString fmitprefix/c\QString fmitprefix(STR(/usr));" \
		src/modules/MicrotonalView.cpp || die "PREFIX fix sed failed"
	default
}

src_configure() {
	local config flag
	for flag in alsa jack portaudio oss; do
		use ${flag} && config+=" acs_${flag}"
	done

	eqmake6 CONFIG+="${config}" fmit.pro PREFIX="${ED}"/usr \
		PREFIXSHORTCUT="${ED}"/usr DISTDIR=/usr
}
