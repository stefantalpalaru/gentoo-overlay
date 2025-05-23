# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 pypi

DESCRIPTION="Python module for spawning child apps and responding to expected patterns"
HOMEPAGE="https://pexpect.readthedocs.io/
		https://pypi.org/project/pexpect/
		https://github.com/pexpect/pexpect/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples test"
RESTRICT="mirror test"

RDEPEND=">=dev-python/ptyprocess-0.5[${PYTHON_USEDEP}]
	!<dev-python/pexpect-4.8.0-r200[${PYTHON_USEDEP}]
"
DEPEND="
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-sphinx-3.patch
)

python_compile_all() {
	use doc && emake -C doc html
}

python_install() {
	distutils-r1_python_install
	# https://bugs.gentoo.org/703100
	rm "${D}$(python_get_sitedir)/pexpect/_async.py" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
