# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit flag-o-matic distutils-r1

DESCRIPTION="YAML parser and emitter for Python"
HOMEPAGE="https://pyyaml.org/wiki/PyYAML
	https://pypi.org/project/PyYAML/
	https://github.com/yaml/pyyaml"
SRC_URI="https://github.com/yaml/pyyaml/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +libyaml"
RESTRICT="mirror"

RDEPEND="libyaml? ( dev-libs/libyaml:= )
	!<dev-python/pyyaml-5.3.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	libyaml? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		' 'python*')
	)"

PATCHES=(
	# bug #659348
	"${FILESDIR}/pyyaml-5.1-cve-2017-18342.patch"
)

distutils_enable_tests setup.py

src_prepare() {
	default
	append-cflags -fpermissive
}

python_configure_all() {
	DISTUTILS_ARGS=( $(use_with libyaml) )
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}
	fi
}
