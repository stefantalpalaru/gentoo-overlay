# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="Nim language support"
HOMEPAGE="https://github.com/zah/nim.vim"
my_commit="88f5e708a739fb26be6364ab2fabadf9fffb8d7b"
SRC_URI="https://github.com/zah/nim.vim/archive/${my_commit}.zip -> ${P}.zip"

LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/nim.vim-${my_commit}"
