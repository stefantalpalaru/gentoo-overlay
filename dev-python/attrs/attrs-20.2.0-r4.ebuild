# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Attributes without boilerplate"
HOMEPAGE="
	https://github.com/python-attrs/attrs
	https://attrs.readthedocs.org/
	https://pypi.org/project/attrs/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]
	!<dev-python/attrs-20.2.0-r3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		>=dev-python/hypothesis-3.6.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
