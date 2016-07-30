# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://gitlab.com/pycqa/flake8 https://pypi.python.org/pypi/flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="test"
LICENSE="MIT"
SLOT="0"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/pyflakes-0.8.1[${PYTHON_USEDEP}]
	<dev-python/pyflakes-1.3.0[${PYTHON_USEDEP}]
	!=dev-python/pyflakes-1.2.0[${PYTHON_USEDEP}]
	!=dev-python/pyflakes-1.2.1[${PYTHON_USEDEP}]
	!=dev-python/pyflakes-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.0.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${PDEPEND}
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/mccabe-0.5.0[${PYTHON_USEDEP}]
		<dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	)"
PDEPEND="
	>=dev-python/mccabe-0.5.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	# this one fails
	rm tests/unit/test_config_file_finder.py

	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die "testsuite failed under ${EPYTHON}"
}

pkg_postinst() {
	ewarn "if '--ignore' seems broken with entire error classes"
	ewarn "it's because you now need to also eliminate them from '--select' which defaults to 'E,F,W,C'"
	ewarn "E.g.: --ignore=E,W,F403 --select=F,C"
}
