# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Character encoding aliases for legacy web content"
HOMEPAGE="https://github.com/SimonSapin/python-webencodings
		https://pypi.org/project/webencodings/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror"

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
