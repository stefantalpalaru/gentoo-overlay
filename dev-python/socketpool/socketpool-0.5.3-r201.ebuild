# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A simple Python socket pool"
HOMEPAGE="https://github.com/benoitc/socketpool/"
LICENSE="|| ( MIT public-domain )"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 s390 ~sparc x86"
IUSE="examples test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/gevent[${PYTHON_USEDEP}]
	!<dev-python/socketpool-0.5.3-r200[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.5.2-locale.patch )

python_test() {
	cp -r examples tests "${BUILD_DIR}" || die

	pushd "${BUILD_DIR}" >/dev/null || die
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
	popd >/dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples

	# package installs unneeded LICENSE files here
	rm -r "${ED}"/usr/socketpool || die
}
