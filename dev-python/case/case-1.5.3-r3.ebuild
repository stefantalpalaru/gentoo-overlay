# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python unittest Utilities"
HOMEPAGE="https://pypi.org/project/case https://github.com/celery/case"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="mirror test"

RDEPEND=">=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
	>=dev-python/mock-2.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/case-1.5.3-r2[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
