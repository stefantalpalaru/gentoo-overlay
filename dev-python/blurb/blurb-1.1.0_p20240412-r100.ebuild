# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )
MY_COMMIT="68193f0c2a931e0f5fdc68776ad9f3e39b332162"

inherit distutils-r1

DESCRIPTION="Tool to create and manage NEWS blurbs for CPython"
HOMEPAGE="https://github.com/python/blurb"
SRC_URI="https://github.com/python/blurb/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/blurb-${MY_COMMIT}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/blurb-1.1.0-version.patch"
)

src_test() {
	# Tests expect to be run from github repo, in which code is inside dir
	ln -s . blurb || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" -m blurb test || die "Tests failed with ${EPYTHON}"
}
