# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Google's Python argument parsing library"
HOMEPAGE="https://github.com/google/python-gflags"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86"
RESTRICT="mirror"

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
