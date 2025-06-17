# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A pure-Python WSGI server"
HOMEPAGE="https://docs.pylonsproject.org/projects/waitress/en/latest/
	https://pypi.org/project/waitress/
	https://github.com/Pylons/waitress"
LICENSE="ZPL"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/waitress-1.4.4-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -i \
		-e 's:--cov::' \
		-e 's/waitress-serve = waitress.runner:run/waitress-serve_py2 = waitress.runner:run/' \
		setup.cfg || die
	distutils-r1_src_prepare
}
