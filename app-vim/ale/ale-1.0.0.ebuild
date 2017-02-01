# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/w0rp/ale"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/w0rp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Asynchronous Lint Engine for vim"
HOMEPAGE="https://github.com/w0rp/ale"
LICENSE="BSD-2"

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	default
	rm -r LICENSE stdin_wrapper.d stdin-wrapper.exe || die

	# protect them from ending up as docs
	mkdir ale_scripts
	for script in dmd-wrapper stdin-wrapper; do
		mv "${script}" ale_scripts/ale-"${script}" || die
		sed -i -e "s/${script}/ale-${script}/g" autoload/ale/util.vim ale_linters/d/dmd.vim || die
	done
}

src_install() {
	vim-plugin_src_install
	fperms -R 0755 /usr/share/vim/vimfiles/ale_scripts
	mv "${D}"/usr/share/vim/vimfiles/ale_scripts/* "${D}"/usr/share/vim/vimfiles/ || die
	rm -r "${D}"/usr/share/vim/vimfiles/ale_scripts || die
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
