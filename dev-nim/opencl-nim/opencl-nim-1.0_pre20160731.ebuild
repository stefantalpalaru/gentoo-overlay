# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for OpenCL"
HOMEPAGE="https://github.com/nim-lang/opencl"
EGIT_REPO_URI="https://github.com/nim-lang/opencl"
EGIT_COMMIT="d7bbf5ad6676512e824c0820c986ec018e86c2bb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>dev-lang/nim-0.9.2
	virtual/opencl
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/opencl
	insinto /usr/share/nim/lib/packages/opencl
	doins -r src/*
}
