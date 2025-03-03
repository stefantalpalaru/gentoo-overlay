# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="Nim language support"
HOMEPAGE="https://github.com/zah/nim.vim"
MY_COMMIT="a15714fea392b0f06ff2b282921a68c7033e39a2"
SRC_URI="https://github.com/zah/nim.vim/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/nim.vim-${MY_COMMIT}"
LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
