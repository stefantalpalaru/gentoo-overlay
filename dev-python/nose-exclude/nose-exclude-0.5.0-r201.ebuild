# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Exclude specific directories from nosetests runs"
HOMEPAGE="https://github.com/kgrandis/nose-exclude"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/nose[${PYTHON_USEDEP}]
	!<dev-python/nose-exclude-0.5.0-r200[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
