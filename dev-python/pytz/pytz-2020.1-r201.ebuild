# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="World timezone definitions for Python"
HOMEPAGE="https://pythonhosted.org/pytz/
		https://github.com/stub42/pytz
		https://pypi.org/project/pytz/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

RDEPEND="
	|| ( >=sys-libs/timezone-data-2017a sys-libs/glibc[vanilla] )
	!<dev-python/pytz-2020.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=(
	# Use timezone-data zoneinfo.
	"${FILESDIR}"/2018.4-zoneinfo.patch
	# ...and do not install a copy of it.
	"${FILESDIR}"/${PN}-2018.4-zoneinfo-noinstall.patch
)

python_test() {
	"${EPYTHON}" pytz/tests/test_tzinfo.py -v || die "Tests fail with ${EPYTHON}"
}
