# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Collection of tools for internationalizing Python applications"
HOMEPAGE="https://babel.pocoo.org/
		https://pypi.org/project/Babel/
		https://github.com/python-babel/babel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	!<dev-python/Babel-2.8.0-r4[${PYTHON_USEDEP}]
"
DEPEND="${DEPEND}
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_prepare_all() {
	sed -i \
		-e 's/pybabel = babel.messages.frontend:main/pybabel_py2 = babel.messages.frontend:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

src_test() {
	local -x TZ=UTC
	distutils-r1_src_test
}
