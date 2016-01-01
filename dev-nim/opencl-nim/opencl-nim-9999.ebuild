# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim bindings for OpenCL"
HOMEPAGE="https://github.com/nim-lang/opencl"
EGIT_REPO_URI="https://github.com/nim-lang/opencl"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
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
