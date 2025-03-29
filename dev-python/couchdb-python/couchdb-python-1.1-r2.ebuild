# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN=CouchDB

inherit distutils-r1 pypi

MY_PN="CouchDB"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python library for working with CouchDB"
HOMEPAGE="https://github.com/djc/couchdb-python
		https://pypi.org/project/CouchDB/"
S=${WORKDIR}/${MY_P}
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc"
# Tests require connectivity to a couchdb server.
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/couchdb-python-1.1-r1[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/'couchpy = couchdb.view:main'/'couchpy_py2 = couchdb.view:main'/" \
		-e "s/'couchdb-dump = couchdb.tools.dump:main'/'couchdb-dump_py2 = couchdb.tools.dump:main'/" \
		-e "s/'couchdb-load = couchdb.tools.load:main'/'couchdb-load_py2 = couchdb.tools.load:main'/" \
		-e "s/'couchdb-replicate = couchdb.tools.replicate:main'/'couchdb-replicate_py2 = couchdb.tools.replicate:main'/" \
		-e "s/'couchdb-load-design-doc = couchdb.loader:main'/'couchdb-load-design-doc_py2 = couchdb.loader:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
