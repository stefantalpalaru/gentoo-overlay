# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="WebTest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Helper to test WSGI applications"
HOMEPAGE="https://pypi.org/project/WebTest/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86"

RDEPEND="
	dev-python/paste[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2[${PYTHON_USEDEP}]
	>=dev-python/waitress-0.8.5[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4-python2[${PYTHON_USEDEP}]
	!<dev-python/webtest-2.0.35-r2[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}/webtest-2.0.33-no-pylons-theme.patch"
)

distutils_enable_sphinx docs
