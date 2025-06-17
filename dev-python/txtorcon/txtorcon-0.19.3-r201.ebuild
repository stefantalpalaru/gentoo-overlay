# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Twisted-based Tor controller client, with state-tracking and config abstractions"
HOMEPAGE="https://github.com/meejah/txtorcon
	https://pypi.org/project/txtorcon/
	https://txtorcon.readthedocs.org"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64"
IUSE="doc examples test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/automat:python2[${PYTHON_USEDEP}]
	dev-python/incremental:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.0.0:python2[${PYTHON_USEDEP},crypt]
	>=dev-python/zope-interface-3.6.1:python2[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx:python2[${PYTHON_USEDEP}]
		dev-python/repoze-sphinx-autointerface:python2[${PYTHON_USEDEP}]
	)
	virtual/python-ipaddress[${PYTHON_USEDEP}]
	!<dev-python/txtorcon-0.19.3-r3[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/txtorcon-0.19.3-setup.py-Dontinstallthetests.patch"
	"${FILESDIR}/txtorcon-0.19.3-Movetestsunderthetxtorconnamespace.patch"
	"${FILESDIR}/txtorcon-0.19.3-Removeunconditionalexamples.patch"
	"${FILESDIR}/txtorcon-0.19.3-Removeinstalldocs.patch"
)

python_prepare_all() {
	sed -e "s/^ipaddress.*//" -i requirements.txt || die

	distutils-r1_python_prepare_all
}
python_test() {
	pushd "${TEST_DIR}" > /dev/null || die
	/usr/bin/trial txtorcon || die "Tests failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	use doc && dodoc -r "${S}/docs/_build/html/"*
	use examples && dodoc -r "${S}/examples/"
	distutils-r1_python_install_all
}
