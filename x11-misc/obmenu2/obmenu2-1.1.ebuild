# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_SINGLE_IMPL=1
inherit python-single-r1

DESCRIPTION="Openbox menu editor"
HOMEPAGE="https://github.com/0x10/obmenu2"
SRC_URI="https://github.com/0x10/obmenu2/archive/refs/tags/Version$(ver_rs 1- _).tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="$(python_gen_cond_dep '
	dev-python/pygobject[${PYTHON_USEDEP}]
')"

S="${WORKDIR}/obmenu2-Version$(ver_rs 1- _)"

src_install() {
	python_fix_shebang -f obmenu2
	python_doscript obmenu2
	dodoc README.md
}
