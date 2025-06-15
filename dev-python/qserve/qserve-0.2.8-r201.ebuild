# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A job queue server"
HOMEPAGE="https://github.com/pediapress/qserve
	https://pypi.org/project/qserve/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="dev-python/gevent:python2[${PYTHON_USEDEP}]
	!<dev-python/qserve-0.2.8-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test || die
}
