# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Framework for writing simple command-line applications"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://deb.debian.org/debian/pool/main/s/sclapp/sclapp_${PV}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/pexpect:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<dev-python/sclapp-0.5.3-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-testsuite-fix-from-r235.patch"
)

python_test() {
	esetup.py test
}
