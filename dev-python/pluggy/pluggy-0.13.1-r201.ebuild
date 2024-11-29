# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="plugin and hook calling mechanisms for python"
HOMEPAGE="https://pluggy.readthedocs.io/
		https://github.com/pytest-dev/pluggy
		https://pypi.org/project/pluggy/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/importlib-metadata:python2[${PYTHON_USEDEP}]
	!<dev-python/pluggy-0.13.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	!<dev-python/pluggy-0.13.1-r200[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}"-0.12.0-strip-setuptools_scm.patch )
