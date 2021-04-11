# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library for oEmbed with auto-discovered and manually added providers"
HOMEPAGE="https://github.com/rafaelmartins/pyoembed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/requests:python2[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4-python2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
