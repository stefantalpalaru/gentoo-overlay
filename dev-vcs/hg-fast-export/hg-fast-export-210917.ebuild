# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit python-r1 python-utils-r1

DESCRIPTION="mercurial to git converter using git-fast-import"
HOMEPAGE="https://github.com/frej/fast-export"
SRC_URI="https://github.com/frej/fast-export/archive/refs/tags/v210917.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-vcs/git
	dev-vcs/mercurial[${PYTHON_USEDEP}]
	dev-python/python-pluginloader[${PYTHON_USEDEP}]
	!<dev-vcs/hg-fast-export-200213_p20201010-r1[${PYTHON_USEDEP}]
"

S="${WORKDIR}/fast-export-${PV}"

src_prepare() {
	default
	sed -e "/^ROOT/s:=.*:='${EPREFIX}/usr/bin':" \
		-i "${PN}".sh hg-reset.sh || die
}

src_install() {
	default
	newbin "${PN}".sh "${PN}"
	newbin hg-reset.sh hg-reset
	python_foreach_impl python_fix_shebang -f "${PN}".py
	python_foreach_impl python_doexe "${PN}".py
	python_foreach_impl python_fix_shebang -f hg-reset.py
	python_foreach_impl python_doexe hg-reset.py
	python_foreach_impl python_fix_shebang -f hg2git.py
	python_foreach_impl python_domodule hg2git.py
}
