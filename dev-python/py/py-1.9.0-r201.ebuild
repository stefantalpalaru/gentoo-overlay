# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="https://py.readthedocs.io/en/latest/
		https://github.com/pytest-dev/py
		https://pypi.org/project/py/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"
DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.2-skip-apiwarn-pytest31.patch
	"${FILESDIR}"/${PN}-1.8.0-pytest-4.patch
)

distutils_enable_sphinx doc

src_prepare() {
	# broken on py3.8, don't seem important
	sed -i -e 's:test_syntaxerror_rerepresentation:_&:' \
		-e 's:test_comments:_&:' \
		testing/code/test_source.py || die
	# broken on py3.9, this package is just dead
	sed -i -e 's:test_getfslineno:_&:' \
		testing/code/test_source.py || die

	distutils-r1_src_prepare

	# broken, and relying on exact assertion strings
	rm testing/code/test_assertion.py || die
}
