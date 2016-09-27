# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit webapp

DESCRIPTION="Collectd-web is a web-based front-end for RRD data collected by collectd"
HOMEPAGE="http://collectdweb.appspot.com/"
SRC_URI="https://github.com/httpdss/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

need_httpd_cgi

S="${WORKDIR}/httpdss-collectd-web-8e0ee4a"

DEPEND="dev-perl/HTML-Parser
	net-analyzer/rrdtool[perl,graph]
	dev-perl/JSON
	dev-perl/CGI
	dev-perl/URI
	virtual/perl-Time-Local
	virtual/ttf-fonts"
RDEPEND="${DEPEND}"

src_install() {
	webapp_src_preinst

	cd "${S}"/cgi-bin
	insinto  "${MY_CGIBINDIR}"
	doins -r .
	fperms -R a+x "${MY_CGIBINDIR}"

	cd "${S}"
	insinto  "${MY_HTDOCSDIR}"
	doins -r iphone
	doins -r media
	doins index.html

	webapp_src_install

	ewarn "See setup instructions at: https://wiki.gentoo.org/wiki/Collectd-web ."
	ewarn "In addition to that, you'll need the following in your Apache config:"
	ewarn 'ScriptAlias /collectd-web/collectd-web/cgi-bin/ "/var/www/localhost/cgi-bin/"'
	ewarn ""
}
