# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="An implementation of lxml.xmlfile for the standard library"
HOMEPAGE="https://pypi.org/project/et_xmlfile/
		https://bitbucket.org/openpyxl/et_xmlfile"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/lxml:python2[${PYTHON_USEDEP}]
	!<dev-python/et-xmlfile-1.0.1-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	py.test -vv || die
}
