# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A library to bring functools.singledispatch from Python 3.4 to Python 2.6-3.3"
HOMEPAGE="https://docs.python.org/3/library/functools.html#functools.singledispatch"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
