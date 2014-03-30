# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4} )
DISTUTILS_SRC_TEST="nosetests"

inherit distutils-r1

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="http://pypi.python.org/pypi/kombu https://github.com/celery/kombu"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amqplib doc examples test"

RDEPEND=">=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	amqplib? ( >=dev-python/amqplib-1.0.2[${PYTHON_USEDEP}] )
	>=dev-python/py-amqp-1.4.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose-cover3[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/beanstalkc[${PYTHON_USEDEP}]
	dev-python/couchdb-python[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile_all() {

	local SPHINXBUILD
	if use doc; then
		if python2.7 -c "import django.conf" &> /dev/null; then
			# This will force sphinx-build to use python2.7
			local EPYTHON=python2.7
			export EPYTHON
		else
			die "kombu docs failed installation"
		fi
		einfo "building docs for kombu with python2.7"
		PYTHONPATH="${S}" emake -C docs html
	fi
}

python_test() {
	nosetests --py3where build-${PYTHON_ABI}/lib/${PN}/tests
}

python_install_all() {
	if use examples; then
		docompress -x usr/share/doc/${P}/examples/
		insinto usr/share/doc/${PF}/
		doins -r examples/
	fi
	use doc && dohtml -r docs/.build/html/
	
	distutils-r1_python_install_all
}
