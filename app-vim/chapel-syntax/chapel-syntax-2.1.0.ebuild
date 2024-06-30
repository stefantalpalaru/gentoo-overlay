# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: "
HOMEPAGE="https://github.com/chapel-lang/chapel"
SRC_URI="https://github.com/chapel-lang/chapel/releases/download/${PV}/chapel-${PV}.tar.gz"
S="${WORKDIR}/chapel-${PV}/highlight/vim"
LICENSE="vim"
KEYWORDS="~amd64"
