# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Dead-simple Object-XML mapper for Python"
HOMEPAGE="https://pypi.org/project/dexml/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	!<dev-python/dexml-0.5.1-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
