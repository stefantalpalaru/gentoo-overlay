# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 python3_{10..12} )
DISTUTILS_USE_SETUPTOOLS=manual
PYPI_PN="HeapDict"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Heap with decrease-key and increase-key operations"
HOMEPAGE="http://stutzbachenterprises.com/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}"
DEPEND="
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
"
