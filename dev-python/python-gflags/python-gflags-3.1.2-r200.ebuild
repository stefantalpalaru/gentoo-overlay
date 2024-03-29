# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Google's Python argument parsing library"
HOMEPAGE="https://github.com/google/python-gflags"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

RDEPEND="
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/python-gflags-3.1.2-r200[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-script-install.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	mv gflags2man.py gflags2man_py2.py
	sed -i \
		-e 's/gflags2man\.py/gflags2man_py2.py/' \
		setup.py || die
}

python_test() {
	# note: each test needs to be run separately, otherwise they fail
	"${PYTHON}" -m gflags._helpers_test -v || die
	"${PYTHON}" -m gflags.flags_formatting_test -v || die
	"${PYTHON}" -m gflags.flags_unicode_literals_test -v || die
}
