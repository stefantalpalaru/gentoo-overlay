# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi

DESCRIPTION="Pythonic task execution"
HOMEPAGE="https://pypi.org/project/invoke/
		https://github.com/pyinvoke/invoke"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
# Depends on broken pytest-relaxed plugin
RESTRICT="mirror test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/invoke-1.4.1-r2[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/invoke = invoke.main:program.run/invoke_py2 = invoke.main:program.run/' \
		-e 's/inv = invoke.main:program.run/inv_py2 = invoke.main:program.run/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
