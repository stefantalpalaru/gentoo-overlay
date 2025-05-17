# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="Python style guide checker (fka pep8)"
HOMEPAGE="https://pypi.org/project/pycodestyle/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/pycodestyle-2.6.0-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py
distutils_enable_sphinx docs

python_test() {
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py -v --statistics pycodestyle.py || die
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py -v --max-doc-length=72 --testsuite=testsuite || die
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py --doctest -v || die
}

python_install() {
	distutils-r1_python_install
	mv "${ED}/usr/bin/${PN}" "${ED}/usr/bin/${PN}"_py2
	mv "${ED}/usr/lib/python-exec/python2.7/${PN}" "${ED}/usr/lib/python-exec/python2.7/${PN}"_py2
}
