# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 eutils

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="https://ipyparallel.readthedocs.io/
		https://github.com/ipython/ipyparallel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

# About tests and tornado
# Upstreams claims to work fine with tornado 5, and it's indeed possible to
# launch a cluster with tornado 5 installed, but tests definitely don't run with
# tornado 5 installed. Upstreams CI runs with tornado 4. This is why we limit
# ourselves to <tornado-5 when running tests.

RDEPEND="
	dev-python/decorator:python2[${PYTHON_USEDEP}]
	dev-python/ipykernel:python2[${PYTHON_USEDEP}]
	dev-python/ipython:python2[${PYTHON_USEDEP}]
	dev-python/ipython_genutils:python2[${PYTHON_USEDEP}]
	dev-python/jupyter_client:python2[${PYTHON_USEDEP}]
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0:python2[${PYTHON_USEDEP}]
	www-servers/tornado:python2[${PYTHON_USEDEP}]
	!<dev-python/ipyparallel-6.2.4-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/ipython[test]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		<www-servers/tornado-5
	)
	"

PATCHES=(
	#"${FILESDIR}/${PN}-6.2.3-disable-broken-test.patch"
)

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	mv etc/ipyparallel-serverextension.json etc/ipyparallel-serverextension_py2.json
	mv etc/ipyparallel-nbextension.json etc/ipyparallel-nbextension_py2.json
	sed -i \
		-e 's/ipcluster = ipyparallel.apps.ipclusterapp:launch_new_instance/ipcluster_py2 = ipyparallel.apps.ipclusterapp:launch_new_instance/' \
		-e 's/ipcontroller = ipyparallel.apps.ipcontrollerapp:launch_new_instance/ipcontroller_py2 = ipyparallel.apps.ipcontrollerapp:launch_new_instance/' \
		-e 's/ipengine = ipyparallel.apps.ipengineapp:launch_new_instance/ipengine_py2 = ipyparallel.apps.ipengineapp:launch_new_instance/' \
		-e 's/ipyparallel-serverextension.json/ipyparallel-serverextension_py2.json/' \
		-e 's/ipyparallel-nbextension.json/ipyparallel-nbextension_py2.json/' \
		setup.py || die
	sed -i \
		-e 's#nbextensions/ipyparallel#nbextensions/ipyparallel_py2#' \
		setup.py ipyparallel/nbextension/static/main.js || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${D}/usr/etc" "${D}/"
}

python_test() {
	pytest -vs ipyparallel/tests || die
}

pkg_postinst() {
	optfeature "Jupyter Notebook integration" dev-python/notebook
}
