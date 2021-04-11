# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 optfeature

MY_P=${P^}
DESCRIPTION="A Python templating language"
HOMEPAGE="https://www.makotemplates.org/ https://pypi.org/project/Mako/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${PN^}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	>=dev-python/markupsafe-0.9.2[${PYTHON_USEDEP}]
	!<dev-python/mako-1.1.3-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	# seriously?
	sed -i -e 's:from nose import:from unittest import:' \
		test/__init__.py || die

	sed -i \
		-e 's/mako-render = mako.cmd:cmdline/mako-render_py2 = mako.cmd:cmdline/' \
		setup.py || die

	distutils-r1_src_prepare
}

python_install_all() {
	rm -r doc/build || die

	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "Optional dependencies:"
	optfeature "caching support" dev-python/beaker
}
