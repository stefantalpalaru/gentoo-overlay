# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="A jQuery-like library for python"
HOMEPAGE="https://github.com/gawel/pyquery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/lxml-2.1:python2[${PYTHON_USEDEP}]
	>dev-python/cssselect-0.7.9:python2[${PYTHON_USEDEP}]
	>=dev-python/webob-1.1.9:python2[${PYTHON_USEDEP}]
	!<dev-python/pyquery-1.4.1-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/beautifulsoup[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/restkit[${PYTHON_USEDEP}]' 'python2_7')
	)"

RESTRICT+=" !test? ( test )"

PATCHES=(
	"${FILESDIR}/pyquery-1.4.1-network-tests.patch"
	"${FILESDIR}/pyquery-1.4.1-tests-pypy.patch"
)

python_test() {
	# The suite, it appears, requires this hard setting of PYTHONPATH!
	PYTHONPATH=. nosetests || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Support for BeautifulSoup3 as a parser backend" dev-python/beautifulsoup
}
