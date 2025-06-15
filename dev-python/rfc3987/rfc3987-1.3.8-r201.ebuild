# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Parsing and validation of URIs (RFC 3986) and IRIs (RFC 3987)"
HOMEPAGE="https://github.com/dgerber/rfc3987
		https://pypi.org/project/rfc3987/"
LICENSE="GPL-3"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="dev-python/regex:python2[${PYTHON_USEDEP}]
	!<dev-python/rfc3987-1.3.8-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_test() {
	${EPYTHON} -m doctest -v "${S}/${PN}.py" || die
}
