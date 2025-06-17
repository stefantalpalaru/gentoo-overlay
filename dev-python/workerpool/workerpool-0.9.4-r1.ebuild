# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Module for distributing jobs to a pool of worker threads"
HOMEPAGE="https://github.com/shazow/workerpool"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -v test || die
}
