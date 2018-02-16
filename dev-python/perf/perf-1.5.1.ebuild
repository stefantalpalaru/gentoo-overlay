# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )
inherit distutils-r1

DESCRIPTION="toolkit to run Python benchmarks"
HOMEPAGE="https://github.com/vstinner/perf"
SRC_URI="https://github.com/vstinner/perf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-1.5.1-pread.patch"
)

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/statistics[${PYTHON_USEDEP}]' python2_7 )
"
DEPEND="${RDEPEND}"
