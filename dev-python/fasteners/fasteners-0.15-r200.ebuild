# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Python package that provides useful locks"
HOMEPAGE="https://github.com/harlowja/fasteners"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/monotonic-0.1[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/fasteners-0.15-r3[${PYTHON_USEDEP}]
"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/futures[${PYTHON_USEDEP}]
		' -2)
	)"

python_test() {
	nosetests -v || die
}
