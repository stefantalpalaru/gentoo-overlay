# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fast, pure-Python database engine"
HOMEPAGE="http://buzhug.sourceforge.net/ https://pypi.org/project/buzhug/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="app-arch/unzip
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
