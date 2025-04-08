# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python client library for accessing the disqus.com API"
HOMEPAGE="https://github.com/disqus/disqus-python"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="dev-python/nose[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"
RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" "${S}/disqusapi/tests.py" || die
}
