# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Enchant spellchecking system"
HOMEPAGE="http://pyenchant.sourceforge.net https://pypi.org/project/pyenchant/"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="app-text/enchant:0
	!<dev-python/pyenchant-2.0.0-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		app-dicts/myspell-en
	)"

python_prepare_all() {
	# Avoid a test failure when there is no dictionary
	# matching the available locales
	# https://github.com/rfk/pyenchant/issues/134
	sed -i 's/test_default_language/_&/' enchant/checker/tests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
