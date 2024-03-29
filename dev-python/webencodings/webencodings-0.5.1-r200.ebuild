# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Character encoding aliases for legacy web content"
HOMEPAGE="https://github.com/SimonSapin/python-webencodings
		https://pypi.org/project/webencodings/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	!<dev-python/webencodings-0.5.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	cat >> setup.cfg <<- EOF
	[tool:pytest]
	python_files=test*.py
	EOF
	distutils-r1_python_prepare_all
}
