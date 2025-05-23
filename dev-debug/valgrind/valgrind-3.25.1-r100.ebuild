# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The Valgrind upstream maintainer also maintains it in Fedora and will
# backport fixes there which haven't yet made it into a release. Keep an eye
# on it for fixes we should cherry-pick too:
# https://src.fedoraproject.org/rpms/valgrind/tree/rawhide

inherit autotools flag-o-matic toolchain-funcs multilib pax-utils

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="https://www.valgrind.org"
SRC_URI="https://sourceware.org/pub/valgrind/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="mpi lto"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.7.0-respect-flags.patch
	"${FILESDIR}"/${PN}-3.15.0-Build-ldst_multiple-test-with-fno-pie.patch
	"${FILESDIR}"/${PN}-3.21.0-glibc-2.34-suppressions.patch
	"${FILESDIR}"/valgrind-3.23.0-strlen.patch
	"${FILESDIR}"/valgrind-3.17.0-bextr.patch
)

QA_CONFIG_IMPL_DECL_SKIP+=(
	# "checking if gcc accepts nested functions" but clang cannot handle good
	# errors and reports both "function definition is not allowed here" and
	# -Wimplicit-function-declaration. bug #900396
	foo
	# FreeBSD function, bug #932822
	aio_readv
)

src_prepare() {
	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${PF}:" docs/Makefile.am || die

	# Don't force multiarch stuff on OSX, bug #306467
	sed -i -e 's:-arch \(i386\|x86_64\)::g' Makefile.all.am || die

	if [[ ${CHOST} == *-solaris* ]] ; then
		# upstream doesn't support this, but we don't build with
		# Sun/Oracle ld, we have a GNU toolchain, so get some things
		# working the Linux/GNU way
		find "${S}" -name "Makefile.am" -o -name "Makefile.tool.am" | xargs \
			sed -i -e 's:-M,/usr/lib/ld/map.noexstk:-z,noexecstack:' || die
		cp "${S}"/coregrind/link_tool_exe_{linux,solaris}.in
	fi

	default

	# Regenerate autotools files
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable lto)
		--with-gdbscripts-dir="${EPREFIX}"/usr/share/gdb/auto-load
	)

	tc-is-lto && myconf+=( --enable-lto )

	# Respect ar, bug #468114
	tc-export AR

	# -fomit-frame-pointer	"Assembler messages: Error: junk `8' after expression"
	#                       while compiling insn_sse.c in none/tests/x86
	# -fstack-protector     more undefined references to __guard and __stack_smash_handler
	#                       because valgrind doesn't link to glibc (bug #114347)
	# -fstack-protector-all    Fails same way as -fstack-protector/-fstack-protector-strong.
	#                          Note: -fstack-protector-explicit is a no-op for Valgrind, no need to strip it
	# -fstack-protector-strong See -fstack-protector (bug #620402)
	# -m64 -mx32			for multilib-portage, bug #398825
	# -fharden-control-flow-redundancy: breaks runtime ('jump to the invalid address stated on the next line')
	filter-flags -fomit-frame-pointer
	filter-flags -fstack-protector
	filter-flags -fstack-protector-all
	filter-flags -fstack-protector-strong
	filter-flags -m64 -mx32
	filter-flags -fsanitize -fsanitize=*
	filter-flags -fharden-control-flow-redundancy
	append-cflags $(test-flags-CC -fno-harden-control-flow-redundancy)
	filter-lto

	if use amd64 || use ppc64; then
		! has_multilib_profile && myconf+=("--enable-only64bit")
	fi

	# Force bitness on darwin, bug #306467
	use x64-macos && myconf+=("--enable-only64bit")

	# Don't use mpicc unless the user asked for it (bug #258832)
	if ! use mpi; then
		myconf+=("--without-mpicc")
	fi

	econf "${myconf[@]}"
}

src_test() {
	# fxsave.o, tronical.o have textrels
	# -fno-strict-aliasing: https://bugs.kde.org/show_bug.cgi?id=486093
	emake CFLAGS="${CFLAGS} -fno-strict-aliasing" LDFLAGS="${LDFLAGS} -Wl,-z,notext" check
}

src_install() {
	default

	dodoc FAQ.txt

	pax-mark m "${ED}"/usr/$(get_libdir)/valgrind/*-*-linux

	# See README_PACKAGERS
	dostrip -x /usr/libexec/valgrind/vgpreload* /usr/$(get_libdir)/valgrind/*

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fix install_names on shared libraries, can't turn them into bundles,
		# as dyld won't load them any more then, bug #306467
		local l
		for l in "${ED}"/usr/lib/valgrind/*.so ; do
			install_name_tool -id "${EPREFIX}"/usr/lib/valgrind/${l##*/} "${l}"
		done
	fi
}

pkg_postinst() {
	elog "Valgrind will not work if libc (e.g. glibc) does not have debug symbols."
	elog "To fix this you can add splitdebug to FEATURES in make.conf"
	elog "and remerge glibc. See:"
	elog "https://bugs.gentoo.org/214065"
	elog "https://bugs.gentoo.org/274771"
	elog "https://bugs.gentoo.org/388703"
}
