# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 bash-completion-r1

DESCRIPTION="Asynchronous task queue/job queue based on distributed message passing"
HOMEPAGE="http://celeryproject.org/ https://pypi.python.org/pypi/celery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
# There are a number of other optional 'extras' which overlap with those of kombu, however
# there has been no apparent expression of interest or demand by users for them. See requires.txt
IUSE="doc examples redis sqs test yaml zeromq"

RDEPEND="
	<dev-python/kombu-3.1:python2[${PYTHON_USEDEP}]
	>=dev-python/kombu-3.0.37:python2[${PYTHON_USEDEP}]
	>=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/billiard-3.3.0.23:python2[${PYTHON_USEDEP}]
	<dev-python/billiard-3.4:python2[${PYTHON_USEDEP}]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
	dev-python/greenlet:python2[${PYTHON_USEDEP}]
	!<dev-python/celery-3.1.25-r200[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/gevent[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		>=dev-python/pymongo-2.6.2[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/redis-py[${PYTHON_USEDEP}]
		>=dev-db/redis-2.8.0
		>=dev-python/boto-2.13.3[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-13.1.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		)"

# testsuite needs it own source
DISTUTILS_IN_SOURCE_BUILD=1
python_prepare_all() {
	eapply -p0 "${FILESDIR}"/celery-docs.patch
	eapply "${FILESDIR}"/${PN}-3.1.19-test.patch

	sed -i \
		-e "s/'celery = celery.__main__:main'/'celery_py2 = celery.__main__:main'/" \
		-e "s/'celeryd = celery.__main__:_compat_worker'/'celeryd_py2 = celery.__main__:_compat_worker'/" \
		-e "s/'celerybeat = celery.__main__:_compat_beat'/'celerybeat_py2 = celery.__main__:_compat_beat'/" \
		-e "s/'celeryd-multi = celery.__main__:_compat_multi'/'celeryd-multi_py2 = celery.__main__:_compat_multi'/" \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		mkdir docs/.build || die
		emake -C docs html
	fi
}

python_test() {
	nosetests --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	# Main celeryd init.d and conf.d
	cp -a "${FILESDIR}/celery.initd-r2" "${TMPDIR}/celery.initd-r2"
	sed -i \
		-e 's/CELERYD_NODES=${CELERYD_NODES:-"celery"}/CELERYD_NODES=${CELERYD_NODES:-"celery_py2"}/' \
		-e 's/CELERYD_MULTI=${CELERYD_MULTI:-"celery multi"}/CELERYD_MULTI=${CELERYD_MULTI:-"celery_py2 multi"}/' \
		-e 's/CELERYCTL=${CELERYCTL:-"celery"}/CELERYCTL=${CELERYCTL:-"celery_py2"}/' \
		-e 's/CELERYBEAT=${CELERYBEAT:-"celery beat"}/CELERYBEAT=${CELERYBEAT:-"celery_py2 beat"}/' \
		"${TMPDIR}/celery.initd-r2" || die
	newinitd "${TMPDIR}/celery.initd-r2" celery_py2
	newconfd "${FILESDIR}/celery.confd-r2" celery_py2

	use examples && local EXAMPLES=( examples/. )

	use doc && local HTML_DOCS=( docs/.build/html/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "zookeper support" dev-python/kazoo
	optfeature "msgpack support" dev-python/msgpack
	#optfeature "rabbitmq support" dev-python/librabbitmq
	#optfeature "slmq support" dev-python/softlayer_messaging
	optfeature "eventlet support" dev-python/eventlet
	#optfeature "couchbase support" dev-python/couchbase
	optfeature "redis support" dev-db/redis dev-python/redis-py
	optfeature "couchdb support" dev-db/couchdb dev-python/couchdb-python
	optfeature "gevent support" dev-python/gevent
	optfeature "auth support" dev-python/pyopenssl
	optfeature "pyro support" dev-python/pyro:4
	optfeature "yaml support" dev-python/pyyaml
	optfeature "beanstalk support" dev-python/beanstalkc
	optfeature "memcache support" dev-python/pylibmc
	#optfeature "threads support" dev-python/threadpool
	optfeature "mongodb support" dev-python/pymongo
	optfeature "zeromq support" dev-python/pyzmq
	optfeature "sqlalchemy support" dev-python/sqlalchemy
	optfeature "sqs support" dev-python/boto
	#optfeature "cassandra support" dev-python/pycassa
}
