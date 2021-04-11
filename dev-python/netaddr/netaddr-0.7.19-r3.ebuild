# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="https://github.com/drkjam/netaddr
		https://pypi.org/project/netaddr/
		https://netaddr.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-python/netaddr-0.7.19-r3[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

python_prepare_all() {
	mv netaddr/tools/netaddr netaddr/tools/netaddr_py2
	sed -i \
		-e "s%scripts=\['netaddr/tools/netaddr'\]%scripts=\['netaddr/tools/netaddr_py2'\]%" \
		-e "s%'executable': '/usr/bin/env python'%'executable': '/usr/bin/env python2'%" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
