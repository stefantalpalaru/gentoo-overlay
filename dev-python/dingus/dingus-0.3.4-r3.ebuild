# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A record-then-assert mocking library"
HOMEPAGE="https://pypi.org/project/dingus/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i -e '/data_files/d' setup.py || die #413769
	distutils-r1_python_prepare_all
}
