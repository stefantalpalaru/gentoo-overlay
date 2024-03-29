# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="A${PN:1}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Self-service finite-state machines for the programmer on the go"
HOMEPAGE="https://github.com/glyph/automat https://pypi.org/project/Automat/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/automat-20.2.0-r3[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-python/m2r[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/automat-0.8.0-no-setup-py-m2r-import.patch"
	"${FILESDIR}/test_visualize-twisted-import-errors.patch"
)

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -r -i \
		-e "s:use_scm_version=True:version='${PV}': ;
			s:[\"']setuptools[_-]scm[\"'](,|)::" \
		-e 's/"automat-visualize = automat._visualize:tool"/"automat-visualize_py2 = automat._visualize:tool"/' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc docs/examples/*.py
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo "For additional visualization functionality install both these optional dependencies"
	einfo "    >=dev-python/twisted-16.1.1"
	einfo "    media-gfx/graphviz[python]"
}
