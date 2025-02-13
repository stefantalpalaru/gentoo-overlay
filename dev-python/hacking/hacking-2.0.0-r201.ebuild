# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/openstack-dev/hacking"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 ~hppa ~ppc64 ~s390 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/flake8-3.6.0:python2[${PYTHON_USEDEP}]
	<dev-python/flake8-4.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0:python2[${PYTHON_USEDEP}]
	!<dev-python/hacking-2.0.0-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-subunit-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		${RDEPEND}
	)
	doc? (
		>=dev-python/sphinx-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/openstackdocstheme-1.18.1[${PYTHON_USEDEP}]
		>=dev-python/reno-2.5.0[${PYTHON_USEDEP}]
	)"
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && sphinx-build -b html -c doc/source/ doc/source/ doc/source/html
}

python_test() {
	stestr init || die "stestr init died"
	stestr run || die "testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "flake8 drew error on a run over ${PN}/tests folder"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/html/. )
	distutils-r1_python_install_all
}
