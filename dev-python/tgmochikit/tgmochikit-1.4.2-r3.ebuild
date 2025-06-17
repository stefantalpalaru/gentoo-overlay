# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="tgMochiKit"
MY_P="${MY_PN}-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="MochiKit packaged as TurboGears widgets"
HOMEPAGE="https://pypi.org/project/tgMochiKit/"
S="${WORKDIR}/${MY_P}"
LICENSE="|| ( AFL-2.1 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "tests failed"
}
