# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python library for oEmbed with auto-discovered and manually added providers"
HOMEPAGE="https://github.com/rafaelmartins/pyoembed"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/requests:python2[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4:python2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
