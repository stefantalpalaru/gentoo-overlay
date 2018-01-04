# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 eutils flag-o-matic git-r3 multilib udev

LICENSE="GPL-2"

DESCRIPTION="mirror/replicate block-devices across a network-connection"
# this package's build system relies on a Git working copy, so we're not just being lazy about using an archived submodule
EGIT_REPO_URI="https://github.com/LINBIT/drbd-utils"
EGIT_COMMIT="v${PV}"
HOMEPAGE="http://www.drbd.org"

KEYWORDS="~amd64 ~x86"
IUSE="bash-completion heartbeat pacemaker +udev xen"
SLOT="0"

COMMON_DEPEND="heartbeat? ( sys-cluster/heartbeat )
	pacemaker? ( sys-cluster/pacemaker )
	udev? ( virtual/udev )
	!!sys-cluster/drbd"
DEPEND="${COMMON_DEPEND}
	sys-devel/flex
"
RDEPEND="${COMMON_DEPEND}"

pkg_pretend() {
	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_prepare() {
	default

	# respect LDFLAGS, #453442
	sed -e "s/\$(CC) -o/\$(CC) \$(LDFLAGS) -o/" \
		-e "/\$(DESTDIR)\$(localstatedir)\/lock/d" \
		-i user/*/Makefile.in || die

	# respect multilib
	sed -i -e "s:/lib/:/$(get_libdir)/:g" \
		Makefile.in scripts/{Makefile.in,global_common.conf,drbd.conf.example} || die
	sed -e "s:@prefix@/lib:@prefix@/$(get_libdir):" \
		-e "s:(DESTDIR)/lib:(DESTDIR)/$(get_libdir):" \
		-i user/*/Makefile.in || die

	# correct install paths (really correct this time)
	sed -i -e "s:\$(sysconfdir)/bash_completion.d:$(get_bashcompdir):" \
		scripts/Makefile.in || die

	# don't participate in user survey bug 360483
	sed -i -e '/usage-count/ s/yes/no/' scripts/global_common.conf || die
	sed -i -e "s:\$(sysconfdir)/udev:$(get_udevdir):" scripts/Makefile.in || die

	# fix buggy C++11 detection
	sed -i -e 's/-z "\$ac_ct_CXX" -o//' configure.ac

	epatch "${FILESDIR}"/run-lock.patch

	autoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--without-rgmanager \
		$(use_with udev) \
		$(use_with xen) \
		$(use_with pacemaker) \
		$(use_with heartbeat) \
		$(use_with bash-completion bashcompletion) \
		--with-distro=gentoo
}

src_compile() {
	# only compile the tools
	emake OPTFLAGS="${CFLAGS}" tools doc
}

src_install() {
	# only install the tools and man pages
	emake DESTDIR="${D}" install-tools install-doc
	dodoc README.md ChangeLog

	# install our own init script
	newinitd "${FILESDIR}"/${PN}-8.0.rc ${PN/-utils/}

	dodoc scripts/drbd.conf.example

	dosym /usr/sbin/drbdadm /sbin/drbdadm
}

pkg_postinst() {
	einfo
	einfo "Please copy and gunzip the configuration file:"
	einfo "from /usr/share/doc/${PF}/${PN/-utils/}.conf.example.bz2 to /etc/${PN/-utils/}.conf"
	einfo "and edit it to your needs. Helpful commands:"
	einfo "man 5 drbd.conf"
	einfo "man 8 drbdsetup"
	einfo "man 8 drbdadm"
	einfo "man 8 drbddisk"
	einfo "man 8 drbdmeta"
	einfo
	elog "Remember to enable drbd support in kernel."
}
