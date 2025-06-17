# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A fairly simple, decently quick python interface to Amazon's S3 storage service"
HOMEPAGE="http://sendapatch.se/projects/simples3/
		https://pypi.org/project/simples3/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

DOCS=( changes.rst README TODO )

python_prepare_all() {
	sed -i -e "s/setuptools/distutils.core/" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
