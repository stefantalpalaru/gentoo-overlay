# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV="${PV/./}"

inherit autotools flag-o-matic fortran-2 multilib-minimal

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio${MY_PV}.tar.gz"
S="${WORKDIR}/cfitsio"
LICENSE="MIT"
SLOT="0/5"
KEYWORDS="~alpha amd64 hppa ppc ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples threads +tools cpu_flags_x86_sse2 cpu_flags_x86_ssse3"
RESTRICT="mirror"

RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	app-arch/bzip2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-lang/cfortran"

PATCHES=(
	"${FILESDIR}/cfitsio-3.410-system-libs.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	# avoid internal cfortran
	mv cfortran.h cfortran.h.disabled
	ln -s "${EPREFIX}"/usr/include/cfortran.h . || die
	default
	append-cflags -std=gnu17
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable threads reentrant) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		--with-bzip2
}

multilib_src_compile() {
	emake all shared
	use tools && emake fitscopy fpack funpack imcopy
}

multilib_src_install_all() {
	dodoc README docs/changes.txt docs/cfitsio.doc
	dodoc docs/fitsio.doc
	use doc && dodoc docs/{quick,cfitsio,fpackguide}.pdf
	use doc && dodoc docs/fitsio.pdf
	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc cookbook.c testprog.c speed.c smem.c
		dodoc cookbook.f testf77.f
	fi
}
