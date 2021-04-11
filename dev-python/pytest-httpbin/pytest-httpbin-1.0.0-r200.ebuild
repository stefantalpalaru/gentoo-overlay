# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Easily test your HTTP library against a local copy of httpbin"
HOMEPAGE="https://github.com/kevin1024/pytest-httpbin
	https://pypi.org/project/pytest-httpbin/"
SRC_URI="https://github.com/kevin1024/pytest-httpbin/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="
	dev-python/httpbin[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/pytest-httpbin-1.0.0-r200[${PYTHON_USEDEP}]
"
