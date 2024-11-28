# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A portable, lightweight MessagePack serializer and deserializer"
HOMEPAGE="https://github.com/vsergeev/u-msgpack-python
		https://pypi.org/project/u-msgpack-python/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="
	!<dev-python/u-msgpack-python-2.7.0-r200[${PYTHON_USEDEP}]
"
