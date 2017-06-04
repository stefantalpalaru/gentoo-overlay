# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="Asynchronous Lint Engine for vim"
HOMEPAGE="https://github.com/w0rp/ale"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/w0rp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	default
	rm LICENSE || die
}

pkg_postinst() {
	vim-plugin_pkg_postinst
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "ALE has many optional dependencies depending on the type"
		elog "of syntax checking being performed. Look in the related files in"
		elog "the ale_linters directory to help figure out what programs"
		elog "different languages need."
	fi
}
