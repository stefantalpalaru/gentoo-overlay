# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A job queue server"
HOMEPAGE="https://github.com/pediapress/qserve
	https://pypi.org/project/qserve/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

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
