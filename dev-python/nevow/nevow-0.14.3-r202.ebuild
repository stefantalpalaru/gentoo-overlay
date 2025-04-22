# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="Nevow"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 twisted-r1 pypi

DESCRIPTION="A web templating framework that provides LivePage, an automatic AJAX toolkit"
HOMEPAGE="https://github.com/twisted/nevow
		https://pypi.org/project/Nevow/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/twisted:python2[${PYTHON_USEDEP}]
	dev-python/zope-interface:python2[${PYTHON_USEDEP}]
	!<dev-python/nevow-0.14.3-r200[${PYTHON_USEDEP}]
"
# JS tests require a JavaScript interpreter ('smjs' or 'js' in PATH)
# and the subunit library
DEPEND="${RDEPEND}
	test? (
		dev-lang/spidermonkey
		dev-python/python-subunit[${PYTHON_USEDEP}]
	)"

TWISTED_PLUGINS=( nevow.plugins )

python_test() {
	trial formless nevow || die "tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	touch "${D}$(python_get_sitedir)"/nevow/plugins/dropin.cache || die
}

python_install_all() {
	distutils-r1_python_install_all

	# TODO: prevent installing it
	rm -r "${D}"/usr/doc || die
}
