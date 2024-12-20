# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Oslo test framework"
HOMEPAGE="https://launchpad.net/oslo"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND="
	>=dev-python/pbr-1.8:python2[${PYTHON_USEDEP}]
	doc? (
		!~dev-python/sphinx-1.6.6[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.6.7[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.0.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/openstackdocstheme-1.18.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.6.2[${PYTHON_USEDEP}]
		>=dev-python/reno-2.5.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-subunit-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stestr-2.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/mox3-0.20.0[${PYTHON_USEDEP}]
	>=dev-python/os-client-config-1.28.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	!<dev-python/oslotest-3.9.0-r3[${PYTHON_USEDEP}]
"

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx -b man
	fi
}

python_test() {
	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPYTHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	if use doc; then
		doman doc/build/man/oslotest.1
	fi

	distutils-r1_python_install_all

	for F in "${ED}/usr/bin/"*; do
		mv "${F}" "${F}_py2"
	done
	mv "${ED}/usr/lib/python-exec/python2.7/oslo_run_pre_release_tests" "${ED}/usr/lib/python-exec/python2.7/oslo_run_pre_release_tests_py2"
}
