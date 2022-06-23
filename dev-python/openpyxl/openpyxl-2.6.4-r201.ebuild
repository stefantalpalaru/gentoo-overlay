# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

MY_P="${P}-3"
DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="https://openpyxl.readthedocs.io/en/stable/"
SRC_URI="https://foss.heptapod.net/openpyxl/openpyxl/-/archive/${PV}/openpyxl-${PV}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/jdcal:python2[${PYTHON_USEDEP}]
	dev-python/et_xmlfile:python2[${PYTHON_USEDEP}]
	!<dev-python/openpyxl-2.6.4-r4[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff,jpeg]
	)"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	pytest -vv || die "Testing failed with ${EPYTHON}"
}
