# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A buffered iterator for reading big arrays in small contiguous blocks"
HOMEPAGE="https://pypi.org/project/arrayterator/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-python/numpy-1.0_rc1:python2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	cd tests || die

	"${PYTHON}" -c "import test_stochastic; test_stochastic.test()" \
		|| die "Tests fail with ${EPYTHON}"
}
