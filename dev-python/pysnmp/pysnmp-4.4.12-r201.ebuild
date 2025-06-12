# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi

DESCRIPTION="Python SNMP library"
HOMEPAGE="https://github.com/etingof/pysnmp
	https://pypi.org/project/pysnmp/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ppc ~sparc x86"
IUSE="doc examples"
RESTRICT="mirror"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
RDEPEND="
	>=dev-python/pyasn1-0.2.3[${PYTHON_USEDEP}]
	dev-python/pysmi[${PYTHON_USEDEP}]
	|| (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
	!<dev-python/pysnmp-4.4.12-r1[${PYTHON_USEDEP}]
"

python_compile_all() {
	default

	if use doc; then
		touch docs/source/conf.py
		emake -C docs html
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/* )
	docinto examples
	use examples && dodoc -r examples/* docs/mibs

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "You may also be interested in the following packages: "
	elog "dev-python/pysnmp-apps - example programs using pysnmp"
	elog "dev-python/pysnmp-mibs - IETF and other mibs"
	elog "dev-python/pysmi - to dump MIBs in python format"
}
