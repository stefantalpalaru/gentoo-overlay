# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://gitlab.com/pycqa/flake8
		https://pypi.org/project/flake8/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/entrypoints-0.3[${PYTHON_USEDEP}]
	<dev-python/entrypoints-0.4[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-2.1.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.5.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.6.0[${PYTHON_USEDEP}]
	dev-python/configparser[${PYTHON_USEDEP}]
	dev-python/enum34[${PYTHON_USEDEP}]
	dev-python/functools32[${PYTHON_USEDEP}]
	dev-python/typing[${PYTHON_USEDEP}]
	!dev-python/pep8[${PYTHON_USEDEP}]
	!<dev-python/flake8-3.7.9-r3[${PYTHON_USEDEP}]
"
PDEPEND="
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${PDEPEND}
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# don't treat warnings as errors when running tests
	sed -r -i '/^[[:space:]]*error[[:space:]]*$/ d' pytest.ini || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/bin/flake8" "${ED}/usr/bin/flake8_py2"
	mv "${ED}/usr/lib/python-exec/python2.7/flake8" "${ED}/usr/lib/python-exec/python2.7/flake8_py2"
}
