# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit python-r1

DESCRIPTION="mercurial to git converter using git-fast-import"
HOMEPAGE="https://github.com/frej/fast-export"
SRC_URI="https://github.com/frej/fast-export/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-vcs/git
	dev-vcs/mercurial[${PYTHON_USEDEP}]
	dev-python/python-pluginloader[${PYTHON_USEDEP}]
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
