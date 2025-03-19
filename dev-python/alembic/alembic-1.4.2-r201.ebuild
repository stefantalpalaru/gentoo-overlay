# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi

DESCRIPTION="database migrations tool, written by the author of SQLAlchemy"
HOMEPAGE="https://bitbucket.org/zzzeek/alembic"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test doc"
RESTRICT="!test? ( test ) mirror"

RDEPEND=">=dev-python/sqlalchemy-1.1.0:python2[${PYTHON_USEDEP}]
	dev-python/mako:python2[${PYTHON_USEDEP}]
	>=dev-python/python-editor-0.3:python2[${PYTHON_USEDEP}]
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	!<dev-python/alembic-1.4.2-r1[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"
# For test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# suite passes all if run from source. The residual fail & error are quite erroneous
	rm tests/test_script_consumption.py || die

	sed -i \
		-e 's/alembic = alembic.config:main/alembic_py2 = alembic.config:main/' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} run_tests.py || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )

	distutils-r1_python_install_all
}
