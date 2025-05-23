# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit distutils-r1 pypi shell-completion

SETUPTOOLS_PV="44.0.0"
WHEEL_PV="0.34.2"

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="
	https://pip.pypa.io/en/stable/
	https://pypi.org/project/pip/
	https://github.com/pypa/pip/"
SRC_URI="
	https://github.com/pypa/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
	test? (
		$(pypi_wheel_url setuptools ${SETUPTOOLS_PV} py2.py3)
		$(pypi_wheel_url wheel ${WHEEL_PV} py2.py3)
	)
"
# PyPI archive does not have tests, so we need to download from GitHub.
# setuptools & wheel .whl files are required for testing, exact version is not very important.
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="test vanilla"
# disable-system-install patch breaks tests
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/setuptools-39.2.0:python2[${PYTHON_USEDEP}]
	!<dev-python/pip-20.3.4[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/csv23[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/scripttest[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-19.3-disable-version-check.patch"
		"${FILESDIR}/${PN}-20.2-no-coverage.patch"
	)
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/pip-20.0.2-disable-system-install.patch" )
	fi

	# TODO
	rm tests/functional/test_new_resolver_user.py || die

	sed -i \
		-e '/pip=pip._internal.cli.main:main/d' \
		setup.py || die

	distutils-r1_python_prepare_all

	if use test; then
		mkdir tests/data/common_wheels/ || die
		cp "${DISTDIR}"/setuptools-${SETUPTOOLS_PV}-py2.py3-none-any.whl \
			tests/data/common_wheels/ || die

		cp "${DISTDIR}"/wheel-${WHEEL_PV}-py2.py3-none-any.whl \
			tests/data/common_wheels/ || die
	fi
}

python_test() {
	if [[ ${EPYTHON} == pypy* ]]; then
		ewarn "Skipping tests on ${EPYTHON} since they are very broken"
		return 0
	fi

	local -a exclude_tests

	# these will be built in to an expression passed to pytest to exclude
	exclude_tests=(
		git
		svn
		bazaar
		mercurial
		version_check
		uninstall_non_local_distutils
		pep518_uses_build_env
		install_package_with_root
		install_editable_with_prefix
		install_user_wheel
		install_from_current_directory_into_usersite
		uninstall_editable_from_usersite
		uninstall_from_usersite_with_dist_in_global_site
		build_env_isolation
		user_config_accepted
		# these fail with new setuptools + distutils_install_for_testing
		double_install_fail
		multiple_exclude_and_normalization
	)

	distutils_install_for_testing --via-root

	# generate the expression to exclude failing tests
	local exclude_expr
	printf -v exclude_expr "or %s " "${exclude_tests[@]}" || die
	exclude_expr="not (${exclude_expr#or })" || die

	local -x GENTOO_PIP_TESTING=1 \
		PATH="${TEST_DIR}/scripts:${PATH}" \
		PYTHONPATH="${TEST_DIR}/lib:${BUILD_DIR}/lib"

	pytest -vv \
		-k "${exclude_expr}" \
		-m "not network" \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	# Prevent dbus auto-launch
	# https://bugs.gentoo.org/692178
	export DBUS_SESSION_BUS_ADDRESS="disabled:"

	local DOCS=( AUTHORS.txt docs/html/**/*.rst )
	distutils-r1_python_install_all

	COMPLETION="${T}"/completion.tmp

	# 'pip completion' command embeds full $0 into completion script, which confuses
	# 'complete' and causes QA warning when running as "${PYTHON} -m pip".
	# This trick sets correct $0 while still calling just installed pip.
	local pipcmd='import sys; sys.argv[0] = "pip2"; import pip.__main__; sys.exit(pip.__main__._main())'

	${PYTHON} -c "${pipcmd}" completion --bash > "${COMPLETION}" || die
	newbashcomp "${COMPLETION}" ${PN}2

	${PYTHON} -c "${pipcmd}" completion --zsh > "${COMPLETION}" || die
	newzshcomp "${COMPLETION}" _pip2
}
