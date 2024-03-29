# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Passive checker for Python programs"
HOMEPAGE="https://github.com/PyCQA/pyflakes
		https://pypi.org/project/pyflakes/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RESTRICT="test"

RDEPEND="${BDEPEND}
	!<dev-python/pyflakes-2.2.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/'pyflakes = pyflakes.api:main'/'pyflakes_py2 = pyflakes.api:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}
