# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit autotools flag-o-matic python-r1 systemd user

DESCRIPTION="Varnish is a state-of-the-art, high-performance HTTP accelerator"
HOMEPAGE="http://www.varnish-cache.org/"
SRC_URI="https://github.com/varnishcache/varnish-cache/archive/${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE="+jemalloc jit static-libs"

CDEPEND="
	sys-libs/readline:0=
	dev-libs/libpcre[jit?]
	jemalloc? ( dev-libs/jemalloc )
	sys-libs/ncurses:0="

#varnish compiles stuff at run time
RDEPEND="
	${PYTHON_DEPS}
	${CDEPEND}
	sys-devel/gcc"

DEPEND="
	${CDEPEND}
	dev-python/docutils
	virtual/pkgconfig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test" #315725

S="${WORKDIR}/varnish-cache-${P}"

pkg_setup() {
	ebegin "Creating varnish user and group"
	enewgroup varnish
	enewuser varnish -1 -1 /var/lib/varnish varnish
	eend $?
}

src_prepare() {
	# Remove -Werror bug #528354
	sed -i -e 's/-Werror\([^=]\)/\1/g' configure.ac

	# https://github.com/varnishcache/varnish-cache/issues/1875
	append-flags "-fexcess-precision=standard"

	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable jit pcre-jit ) \
		$(use_with jemalloc)
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir /var/lib/varnish/

	python_replicate_script "${D}/usr/share/varnish/vmodtool.py"

	newinitd "${FILESDIR}"/varnishlog.initd varnishlog
	newconfd "${FILESDIR}"/varnishlog.confd varnishlog

	newinitd "${FILESDIR}"/varnishncsa.initd varnishncsa
	newconfd "${FILESDIR}"/varnishncsa.confd varnishncsa

	newinitd "${FILESDIR}"/varnishd.initd-r4 varnishd
	newconfd "${FILESDIR}"/varnishd.confd-r4 varnishd

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/varnishd.logrotate-r2" varnishd

	diropts -m750

	dodir /var/log/varnish/
	keepdir /var/log/varnish/

	systemd_dounit "${FILESDIR}/${PN}d.service"

	insinto /etc/varnish/
	doins lib/libvmod_std/vmod.vcc
	doins etc/example.vcl

	dodoc README.rst
	dodoc doc/changes.rst

	fowners root:varnish /etc/varnish/
	fowners varnish:varnish /var/lib/varnish/
	fperms 0750 /var/lib/varnish/ /etc/varnish/
}
