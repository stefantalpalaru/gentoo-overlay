# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://bitbucket.org/logilab/astroid https://pypi.org/project/astroid/"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ppc ppc64 sparc x86 ~x64-macos"
IUSE="test"
# still broken
RESTRICT="mirror test"

# Version specified in __pkginfo__.py.
RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	!<dev-python/astroid-1.6.6-r200[${PYTHON_USEDEP}]
"
DEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? (
#		${RDEPEND}
#		>=dev-python/pylint-1.4.0[${PYTHON_USEDEP}]
#		dev-python/pytest[${PYTHON_USEDEP}]
#		$(python_gen_cond_dep 'dev-python/egenix-mx-base[${PYTHON_USEDEP}]' python2_7)
#	)"
# Required for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	${EPYTHON} -m unittest discover -p "unittest*.py" --verbose || die
}
