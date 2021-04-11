# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python bindings for the cairo library"
HOMEPAGE="https://www.cairographics.org/pycairo/
		https://github.com/pygobject/pycairo"
SRC_URI="https://github.com/pygobject/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=x11-libs/cairo-1.13.1[svg]
	!<dev-python/pycairo-1.18.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests setup.py

python_install() {
	distutils-r1_python_install \
		install_pkgconfig --pkgconfigdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"
	mv "${ED}/usr/include/pycairo" "${ED}/usr/include/pycairo_py2"
	sed -i \
		-e 's#include/pycairo#include/pycairo_py2#' \
		"${ED}/usr/$(get_libdir)/pkgconfig/pycairo.pc" || die
	mv "${ED}/usr/$(get_libdir)/pkgconfig/pycairo.pc" "${ED}/usr/$(get_libdir)/pkgconfig/pycairo_py2.pc"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}
