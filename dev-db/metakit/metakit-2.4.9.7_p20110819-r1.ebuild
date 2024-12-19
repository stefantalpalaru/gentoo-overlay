# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
MY_COMMIT="ab38c5340d8bb6f88fd0339b65cf33a66c4b9400"

inherit flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Embedded database library"
HOMEPAGE="http://www.equi4.com/metakit/
		https://github.com/jnorthrup/metakit"
SRC_URI="https://github.com/jnorthrup/metakit/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="python static tcl"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test"

DEPEND="
	python? ( ${PYTHON_DEPS} )
	tcl? ( >=dev-lang/tcl-8.6:0= )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myconf mycxxflags
	use tcl && myconf+=" --with-tcl=${EPREFIX}/usr/include,${EPREFIX}/usr/$(get_libdir)"
	use static && myconf+=" --disable-shared"
	use static || append-cxxflags -fPIC

	CXXFLAGS="${CXXFLAGS} ${mycxxflags}" unix/configure \
		${myconf} \
		--host=${CHOST} \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--infodir="${EPREFIX}/usr/share/info" \
		--mandir="${EPREFIX}/usr/share/man"
}

src_compile() {
	emake SHLIB_LD="$(tc-getCXX) -shared -Wl,-soname,libmk4.so.2.4"

	if use python; then
		emake \
			SHLIB_LD="$(tc-getCXX) -shared" \
			pyincludedir="$(python_get_includedir)" \
			PYTHON_LIB="-l${EPYTHON}" \
			python
	fi
}

src_install() {
	default

	mv "${ED}"//usr/$(get_libdir)/libmk4.so{,.2.4}
	dosym libmk4.so.2.4 /usr/$(get_libdir)/libmk4.so.2
	dosym libmk4.so.2.4 /usr/$(get_libdir)/libmk4.so

	if use python; then
		mkdir -p "${D}$(python_get_sitedir)" || die
		emake \
			DESTDIR="${D}" \
			pylibdir="$(python_get_sitedir)" \
			install-python
	fi

	dodoc -r doc/*
}
