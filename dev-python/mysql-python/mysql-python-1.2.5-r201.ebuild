# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic pypi

MY_PN="MySQL-python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python interface to MySQL"
HOMEPAGE="https://sourceforge.net/projects/mysql-python/
		https://pypi.python.org/pypi/MySQL-python"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}" "${PV}" .zip)"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"
RESTRICT="mirror test"

RDEPEND="virtual/mysql
	!<dev-python/mysql-python-1.2.5-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

DOCS=( HISTORY README.md doc/{FAQ,MySQLdb}.rst )

PATCHES=(
	"${FILESDIR}"/mariadb.patch
	"${FILESDIR}"/include.patch
)

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_compile_all() {
	use doc && sphinx-build -b html doc doc/_build/
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/. )
	distutils-r1_python_install_all
}
