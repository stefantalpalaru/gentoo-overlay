# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="CouchDB"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python library for working with CouchDB"
HOMEPAGE="https://github.com/djc/couchdb-python https://pypi.org/project/CouchDB/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/couchdb-python-1.1-r1[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

# Tests require connectivity to a couchdb server.
# Re-enable when the ebuild is capable of starting a local couchdb
# instance.
RESTRICT=test

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
