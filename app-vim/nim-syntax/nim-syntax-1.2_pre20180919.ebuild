# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="Nim language support"
HOMEPAGE="https://github.com/zah/nim.vim"
my_commit="b0c4c6c7318866e5d74715885cb379aab70d2763"
SRC_URI="https://github.com/zah/nim.vim/archive/${my_commit}.zip -> ${P}.zip"

LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/nim.vim-${my_commit}"
