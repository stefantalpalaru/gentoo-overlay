# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="85640223047d49a305e90ba1b92303eb066ba474"

DESCRIPTION="Tom's Audio Processing LADSPA plugins"
HOMEPAGE="https://tomscii.sig7.se/tap-plugins/
		https://git.hq.sig7.se/tap-plugins.git"
SRC_URI="https://git.hq.sig7.se/tap-plugins.git/snapshot/${MY_COMMIT}.tar.gz  -> ${P}.tar.gz"
S="${WORKDIR}/tap-plugins-${MY_COMMIT:0:7}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/tap-plugins-1.0.1-makefile.patch
)

src_install() {
	emake INSTALL_PLUGINS_DIR="${D}/usr/$(get_libdir)/ladspa/" INSTALL_LRDF_DIR="${D}/usr/share/ladspa/rdf/" install
}
