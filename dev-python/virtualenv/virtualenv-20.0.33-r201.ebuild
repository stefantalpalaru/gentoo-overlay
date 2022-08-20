# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="python2"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/appdirs-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/distlib-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/filelock-3[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	dev-python/importlib_resources[${PYTHON_USEDEP}]
	dev-python/pathlib2[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	!<dev-python/virtualenv-20.0.33-r200[${PYTHON_USEDEP}]
"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
	)"

src_prepare() {
	# we don't have xonsh
	rm tests/unit/activation/test_xonsh.py || die
	# require internet
	sed -e 's:test_seed_link_via_app_data:_&:' \
		-i tests/unit/seed/embed/test_boostrap_link_via_app_data.py || die
	# TODO: investigate
	sed -e 's:test_cross_major:_&:' \
		-i tests/unit/create/test_creator.py || die

	sed -i \
		-e 's/virtualenv=virtualenv.__main__:run_with_catch/virtualenv_py2=virtualenv.__main__:run_with_catch/' \
		setup.cfg || die

	distutils-r1_src_prepare
}

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	distutils_install_for_testing

	pytest -vv || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	elog "Please note that while virtualenv package no longer supports"
	elog "Python 2.7, you can still create py2.7 virtualenvs via:"
	elog "  $ virtualenv -p 2.7 ..."
}
