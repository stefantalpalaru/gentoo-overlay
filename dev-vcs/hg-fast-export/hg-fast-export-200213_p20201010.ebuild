# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit python-r1

DESCRIPTION="mercurial to git converter using git-fast-import"
HOMEPAGE="https://github.com/frej/fast-export"
COMMIT="ead75895b058d16ffc7330dab78054c94a189377"
SRC_URI="https://github.com/frej/fast-export/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-vcs/git
	dev-vcs/mercurial
	dev-python/python-pluginloader[${PYTHON_USEDEP}]"

S="${WORKDIR}/fast-export-${COMMIT}"

src_prepare() {
	default
	sed -e "/^ROOT/s:=.*:='${EPREFIX}/usr/bin':" \
		-i "${PN}".sh hg-reset.sh || die
}

src_install() {
	default
	newbin "${PN}".sh "${PN}"
	newbin hg-reset.sh hg-reset
	python_foreach_impl python_doexe "${PN}".py
	python_foreach_impl python_doexe hg-reset.py
	python_foreach_impl python_domodule hg2git.py
}
