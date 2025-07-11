# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MYP="Healpix_${PV}"
MYPF=${MYP}_2016Aug26

inherit autotools toolchain-funcs java-pkg-opt-2 java-ant-2

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/healpix/${MYP}/${MYPF}.tar.gz"
S="${WORKDIR}/${MYP}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# might add fortran in the future if requested
IUSE="cxx doc idl java openmp static-libs"
RESTRICT="mirror test"

RDEPEND="
	>=sci-libs/cfitsio-3
	idl? (
		dev-lang/gdl
		sci-astronomy/idlastro )
	java? ( >=virtual/jre-1.6:* )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.6:* )"

PATCHES=(
	"${FILESDIR}"/healpix-3.31-cfitsio-4.patch
)

pkg_pretend() {
	if use cxx && use openmp && [[ $(tc-getCXX)$ == *g++* ]] && [[ ${MERGE_TYPE} != binary ]]; then
		tc-check-openmp
	fi
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	pushd src/C/autotools > /dev/null
	eautoreconf
	popd > /dev/null
	# why was static-libtool-libs forced?
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		sed -i -e '/-static-libtool-libs/d' Makefile.am || die
		eautoreconf
		popd > /dev/null
	fi
	# duplicate of idlastro (in rdeps)
	rm -r src/idl/zzz_external/astron || die
	mv src/idl/zzz_external/README src/idl/README.external || die
	java-pkg-opt-2_src_prepare
	default
}

src_configure() {
	pushd src/C/autotools > /dev/null
	econf $(use_enable static-libs static)
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		econf \
			--disable-native-optimizations \
			$(use_enable openmp) \
			$(use_enable static-libs static)
		popd > /dev/null
	fi
}

src_compile() {
	pushd src/C/autotools > /dev/null
	emake
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		emake
		popd > /dev/null
	fi
	if use java; then
		pushd src/java > /dev/null
		eant dist-notest
		popd > /dev/null
	fi
}

src_install() {
	dodoc READ_Copyrights_Licenses.txt
	pushd src/C/autotools > /dev/null
	emake install DESTDIR="${D}"
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		emake install DESTDIR="${D}"
		docinto cxx
		dodoc ../CHANGES
		popd > /dev/null
	fi
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/"*.la
	if use idl; then
		pushd src/idl > /dev/null
		insinto /usr/share/gnudatalanguage/healpix
		doins -r examples fits interfaces misc toolkit visu zzz_external
		doins HEALPix_startup
		docinto idl
		dodoc README.*
		popd > /dev/null
	fi
	if use java; then
		pushd src/java > /dev/null
		java-pkg_dojar dist/*.jar
		docinto java
		dodoc README CHANGES
		popd > /dev/null
	fi
	use doc && dodoc -r doc/html
}
