# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A general-purpose (yacc-compatible) parser generator"
HOMEPAGE="https://www.gnu.org/software/bison/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="nls static test"
RESTRICT="mirror !test? ( test )"

RDEPEND=">=sys-devel/m4-1.4.16"
DEPEND="${RDEPEND}
	sys-devel/flex
	nls? ( sys-devel/gettext )
	test? ( dev-lang/perl )"

DOCS="AUTHORS ChangeLog-2012 NEWS README THANKS TODO" # ChangeLog-1998 PACKAGING README-alpha README-release

PATCHES=(
	"${FILESDIR}"/bison-2.7.1-glibc.patch
)

src_configure() {
	use static && append-ldflags -static

	# We don't need perl unless we run tests.
	use test || export ac_cv_path_PERL=true
	econf \
		$(use_enable nls)
}

src_install() {
	default

	# This one is installed by dev-util/yacc
	mv "${ED}"/usr/bin/yacc{,.bison} || die
	mv "${ED}"/usr/share/man/man1/yacc{,.bison}.1 || die

	# We do not need liby.a
	rm -r "${ED}"/usr/lib* || die

	# Move to documentation directory and leave compressing for EAPI>=4
	mv "${ED}"/usr/share/${PN}/README "${ED}"/usr/share/doc/${PF}/README.data
}

pkg_postinst() {
	local f="${EROOT}/usr/bin/yacc"
	if [[ ! -e ${f} ]] ; then
		ln -s yacc.bison "${f}"
	fi
}

pkg_postrm() {
	# clean up the dead symlink when we get unmerged #377469
	local f="${EROOT}/usr/bin/yacc"
	if [[ -L ${f} && ! -e ${f} ]] ; then
		rm -f "${f}"
	fi
}
