# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Passive checker for Python programs"
HOMEPAGE="https://github.com/PyCQA/pyflakes
		https://pypi.org/project/pyflakes/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

RDEPEND="${BDEPEND}
	!<dev-python/pyflakes-2.1.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/'pyflakes = pyflakes.api:main'/'pyflakes_py2 = pyflakes.api:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}
