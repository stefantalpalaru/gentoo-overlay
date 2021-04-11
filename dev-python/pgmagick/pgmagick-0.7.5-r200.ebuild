# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Yet another boost.python based wrapper for GraphicsMagick"
HOMEPAGE="https://pypi.org/project/pgmagick/ https://github.com/hhatto/pgmagick/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	media-gfx/graphicsmagick:=[cxx]
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	!<dev-python/pgmagick-0.7.5-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( media-fonts/corefonts )"

PATCHES=(
	"${FILESDIR}/pgmagick-boost.patch"
)

python_test() {
	cd test || die

	local t
	for t in test_*.py; do
		"${EPYTHON}" "${t}" || die "test ${t} failed under ${EPYTHON}"
	done
	# As long as the order of python impls is not changed, this will suffice
}
