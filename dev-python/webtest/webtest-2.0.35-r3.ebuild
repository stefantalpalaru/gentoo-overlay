# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYPI_PN="WebTest"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_PN="WebTest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Helper to test WSGI applications"
HOMEPAGE="https://pypi.org/project/WebTest/"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~s390 sparc x86"
RESTRICT="test"

RDEPEND="
	dev-python/paste[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2[${PYTHON_USEDEP}]
	>=dev-python/waitress-0.8.5[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4:python2[${PYTHON_USEDEP}]
	!<dev-python/webtest-2.0.35-r2[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}/webtest-2.0.33-no-pylons-theme.patch"
)

distutils_enable_sphinx docs
