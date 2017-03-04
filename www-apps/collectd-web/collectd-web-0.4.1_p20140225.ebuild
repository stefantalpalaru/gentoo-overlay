# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 webapp

DESCRIPTION="Collectd-web is a web-based front-end for RRD data collected by collectd"
HOMEPAGE="https://github.com/httpdss/collectd-web"
EGIT_REPO_URI="https://github.com/httpdss/collectd-web"
EGIT_COMMIT="70a277d8689ed91febac2be097c2d837fcde4283"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

need_httpd_cgi

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
