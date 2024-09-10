# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: Next generation completion framework after neocomplcache"
HOMEPAGE="https://github.com/Shougo/neocomplete.vim"
EGIT_REPO_URI="https://github.com/Shougo/neocomplete.vim.git"

LICENSE="MIT"

RDEPEND="|| (
>app-editors/vim-7.3.885[lua]
>app-editors/gvim-7.3.885[lua] )
!app-vim/neocomplcache"

VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""
