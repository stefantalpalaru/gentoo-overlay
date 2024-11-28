# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi virtualx

DESCRIPTION="A cross-platform clipboard module for Python."
HOMEPAGE="https://github.com/asweigart/pyperclip"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 arm arm64 hppa ~ppc64 sparc x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	|| (
		x11-misc/xclip
		x11-misc/xsel
		dev-python/pyqt5[${PYTHON_USEDEP}]
	)
	!<dev-python/pyperclip-1.8.0-r200[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" tests/test_pyperclip.py -vv ||
		die "Tests fail on ${EPYTHON}"
}

src_test() {
	virtx distutils-r1_src_test
}
