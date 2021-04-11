# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Heap with decrease-key and increase-key operations"
HOMEPAGE="http://stutzbachenterprises.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
"
