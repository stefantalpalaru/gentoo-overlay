# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Add a progress meter to your loops in a second"
HOMEPAGE="https://github.com/tqdm/tqdm"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~sparc x86"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	!<dev-python/tqdm-4.62.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests nose

python_prepare_all() {
	sed -r \
		-e "s:'nose'(,[[:space:]]*|)::" \
		-e "s:'flake8'(,[[:space:]]*|)::" \
		-e "s:'coverage'(,[[:space:]]*|)::" \
		-i setup.py

	sed -i \
		-e 's/tqdm=tqdm.cli:main/tqdm_py2=tqdm.cli:main/' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	# tests_main.py requires the package to be installed
	distutils_install_for_testing
	# Skip unpredictable performance tests
	nosetests tqdm -v --ignore 'tests_perf.py' \
		|| die "tests failed with ${EPYTHON}"
}

python_install() {
	#doman "${BUILD_DIR}"/lib/tqdm/tqdm.1
	rm "${BUILD_DIR}"/lib/tqdm/tqdm.1 || die
	distutils-r1_python_install --skip-build
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
