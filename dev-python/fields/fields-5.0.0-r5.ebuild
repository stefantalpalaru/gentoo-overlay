# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Container class boilerplate killer"
HOMEPAGE="https://github.com/ionelmc/python-fields"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	!<dev-python/fields-5.0.0-r5[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -r \
		-e "/--benchmark-disable/d" \
		-e 's|\[pytest\]|\[tool:pytest\]|' \
		-e '/^[[:space:]]*--doctest-modules[[:space:]]*$/ d' \
		-i setup.cfg || die

	rm -rf tests/test_perf.py || die
	distutils-r1_python_prepare_all
}
