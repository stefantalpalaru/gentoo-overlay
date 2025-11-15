# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 vim-plugin

DESCRIPTION="Asynchronous Lint Engine for vim"
HOMEPAGE="https://github.com/dense-analysis/ale"
EGIT_REPO_URI="https://github.com/dense-analysis/ale"
LICENSE="BSD-2"

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	default
	rm -r test run-tests* Dockerfile LICENSE README.md || die
}

src_install(){
	vim-plugin_src_install ale_linters rplugin lua
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
