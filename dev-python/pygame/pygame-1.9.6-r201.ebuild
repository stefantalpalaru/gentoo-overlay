# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic distutils-r1 pypi virtualx

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="http://www.pygame.org/"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples midi opengl X"

DEPEND="
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	>=media-libs/sdl-image-1.2.2[png,jpeg]
	>=media-libs/sdl-mixer-1.2.4
	>=media-libs/sdl-ttf-2.0.6
	>=media-libs/smpeg-0.4.4-r1
	midi? ( media-libs/portmidi )
	X? ( >=media-libs/libsdl-1.2.5[opengl?,video,X] )
	!X? ( >=media-libs/libsdl-1.2.5 )"
RDEPEND="${DEPEND}
	!<dev-python/pygame-1.9.6-r200[${PYTHON_USEDEP}]
"

# various module import and data path issues
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/pygame-1.9.6-SDL.patch
)

python_configure() {
	PORTMIDI_INC_PORTTIME=1 LOCALBASE="${EPREFIX}/usr" \
		"${EPYTHON}" "${S}"/buildconfig/config.py -auto

	if ! use X; then
		sed -e "s:^scrap :#&:" -i Setup || die "sed failed"
	fi

	# Disable automagic dependency on PortMidi.
	if ! use midi; then
		sed -e "s:^pypm :#&:" -i Setup || die "sed failed"
	fi

	append-cflags "-fno-strict-aliasing -fpermissive"
}

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" virtx "${EPYTHON}" -m pygame.tests
}

python_install() {
	distutils-r1_python_install

	# Bug #497720
	rm -fr "${D}"$(python_get_sitedir)/pygame/{docs,examples,tests}/ || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		docinto html
		dodoc -r docs/*
	fi

	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc -r examples/*
	fi
}
