# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{10..12} )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1 multilib-minimal

DESCRIPTION="A streaming protocol for test results"
HOMEPAGE="https://launchpad.net/subunit
		https://pypi.org/project/python-subunit/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 sparc x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '>=dev-python/testtools-0.9.34:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep '>=dev-python/testtools-0.9.34:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep 'dev-python/extras:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/extras:0[${PYTHON_USEDEP}]' -3)
	dev-lang/perl:="

DEPEND="
	${RDEPEND}
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
	>=dev-libs/check-0.9.11[${MULTILIB_USEDEP}]
	>=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}]
	>=virtual/pkgconfig-0-r1
	test? (
		$(python_gen_cond_dep 'dev-python/fixtures:python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/fixtures:0[${PYTHON_USEDEP}]' -3)
		$(python_gen_cond_dep 'dev-python/hypothesis:python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/hypothesis:0[${PYTHON_USEDEP}]' -3)
		$(python_gen_cond_dep 'dev-python/testscenarios:python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/testscenarios:0[${PYTHON_USEDEP}]' -3)
	)"

# Take out rogue & trivial failing tests that exit the suite before it even gets started
# The removed class in fact works fine in py3 and fails with py2.7 & pupu
# The setu to restrict this patch is just those 2 is not worth it.
PATCHES=( "${FILESDIR}"/1.0.0-tests.patch )

src_prepare() {
	sed -i -e 's/os.chdir(os.path.dirname(__file__))//' setup.py || die

	# Install perl modules in vendor_perl, bug 534654.
	export INSTALLDIRS=vendor

	# needed for perl modules
	distutils-r1_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	default
	multilib_is_native_abi && distutils-r1_src_compile
}

python_test() {
	local -x PATH="${PWD}/shell/share:${PATH}"
	local -x PYTHONPATH=python
	# Following tests are known to fail in py2.7 & pypy. They pass under py3.
	# DO NOT re-file
	# test_add_error test_add_error_details test_add_expected_failure
	# test_add_expected_failure_details test_add_failure test_add_failure
	# https://bugs.launchpad.net/subunit/+bug/1436686

	"${PYTHON}" -m testtools.run all_tests.test_suite || die "Testing failed with ${EPYTHON}"
}

multilib_src_test() {
	multilib_is_native_abi && distutils-r1_src_test
}

multilib_src_install() {
	local targets=(
		install-include_subunitHEADERS
		install-pcdataDATA
		install-exec-local
		install-libLTLIBRARIES
	)
	emake DESTDIR="${D}" "${targets[@]}"

	multilib_is_native_abi && distutils-r1_src_install
}

multilib_src_install_all() {
	einstalldocs
}
