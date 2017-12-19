# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3

DESCRIPTION="solarized version of Numix"
HOMEPAGE="https://github.com/mzgnr/solarized-dark-xfce"
EGIT_REPO_URI="https://github.com/mzgnr/solarized-dark-xfce"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-themes/gtk-engines-murrine
"
DEPEND="
	${RDEPEND}
"

RESTRICT="binchecks strip"

src_install() {
	find -name '*~' -delete
	insinto /usr/share/themes/Numix-Solarized
	doins -r "xfce-theme/Numix Solarized/"*
	ewarn 'the name of the theme is "Numix-Solarized"'
}
