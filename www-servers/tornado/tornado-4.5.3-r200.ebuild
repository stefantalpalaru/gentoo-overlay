# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python web framework and asynchronous networking library"
HOMEPAGE="http://www.tornadoweb.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-python/certifi:python2[${PYTHON_USEDEP}]
	>=dev-python/pycurl-7.19.3.1:python2[${PYTHON_USEDEP}]
	>=dev-python/backports-ssl-match-hostname-3.5[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-16.0.0:python2[${PYTHON_USEDEP}]
		(	dev-python/twisted-names[${PYTHON_USEDEP}]
			dev-python/twisted-web[${PYTHON_USEDEP}]
		)
	)
	dev-python/backports-abc[${PYTHON_USEDEP}]
	dev-python/futures[${PYTHON_USEDEP}]
	dev-python/singledispatch[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
	!<www-servers/tornado-4.5.3-r200[${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

# doc without intersphinx does not build (asyncio error)
#PATCHES=(
#	"${FILESDIR}"/4.5.1-drop-intersphinx.patch
#)

python_test() {
	"${PYTHON}" -m tornado.test.runtests || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r demos/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
