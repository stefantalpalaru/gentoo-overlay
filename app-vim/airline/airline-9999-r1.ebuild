# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: lean & mean statusline for vim that's light as air"
HOMEPAGE="https://github.com/vim-airline/vim-airline/ https://www.vim.org/scripts/script.php?script_id=4661"
EGIT_REPO_URI="https://github.com/vim-airline/vim-airline.git"
LICENSE="MIT"
VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default
}
