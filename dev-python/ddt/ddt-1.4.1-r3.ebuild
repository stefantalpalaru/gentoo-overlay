# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A library to multiply test cases"
HOMEPAGE="https://pypi.org/project/ddt/
		https://github.com/txels/ddt"
SRC_URI="https://github.com/datadriventests/ddt/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 arm64 x86"
IUSE="test"
RESTRICT="mirror"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!<dev-python/ddt-1.4.1-r2[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
