# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A fast and thorough lazy object proxy"
HOMEPAGE="
	https://github.com/ionelmc/python-lazy-object-proxy
	https://pypi.org/project/lazy-object-proxy/
	https://python-lazy-object-proxy.readthedocs.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}]	)"
RDEPEND="
	!<dev-python/lazy-object-proxy-1.4.3-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# No need to benchmark
	sed \
		-e '/benchmark/s:test_:_&:g' \
		-e '/pytest.mark.benchmark/d' \
		-i tests/test_lazy_object_proxy.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v --ignore=src || die "Fails for ${EPYTHON}"
}
