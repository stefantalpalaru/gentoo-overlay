# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-/.}"
PYPI_PN="${MY_PN}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Tools to supplement packaging Python releases"
HOMEPAGE="https://github.com/jaraco/jaraco.packaging"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/importlib-metadata:python2[${PYTHON_USEDEP}]
	>=dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4:python2[${PYTHON_USEDEP}]
	!<dev-python/jaraco-packaging-6.2-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	">=dev-python/rst-linker-1.9"

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i \
		-e "s:setuptools_scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+)[[:space:]]*::" \
		-e 's/dependency-tree=jaraco.packaging.depends:tree_cmd/dependency-tree_py2=jaraco.packaging.depends:tree_cmd/' \
		-e 's/upload-package=jaraco.packaging.cheese:do_upload/upload-package_py2=jaraco.packaging.cheese:do_upload/' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	# Skip one test which requires network access
	# Override pytest options to skip flake8
	PYTHONPATH=. pytest -vv -k "not test_revived_distribution" \
		--override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

# https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages#File_collisions_between_pkgutil-style_packages
python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	# note: eclass may default to --skip-build in the future
	distutils-r1_python_install --skip-build
}
