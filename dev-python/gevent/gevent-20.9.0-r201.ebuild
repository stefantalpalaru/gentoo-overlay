# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Coroutine-based network library"
HOMEPAGE="https://www.gevent.org/
		https://pypi.org/project/gevent/
		https://github.com/gevent/gevent"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-libs/libev-4.23:=
	dev-libs/libuv:=
	>=net-dns/c-ares-1.12:=
	>=dev-python/greenlet-0.4.17:python2[${PYTHON_USEDEP}]
	dev-python/zope-event:python2[${PYTHON_USEDEP}]
	dev-python/zope-interface:python2[${PYTHON_USEDEP}]
	virtual/python-greenlet[${PYTHON_USEDEP}]
	!<dev-python/gevent-20.9.0-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc

python_prepare_all() {
	export LIBEV_EMBED="false"
	export CARES_EMBED="false"
	export EMBED="false"

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_test() {
	cd src/gevent/tests || die
	# TODO: figure out how to make them work and not hang
#	GEVENT_RESOLVER=ares \
#		"${EPYTHON}" -m gevent.tests \
#		-uall,-network \
#		--config known_failures.py \
#		--ignore tests_that_dont_use_resolver.txt || die
#	GEVENT_RESOLVER=dnspython \
#		"${EPYTHON}" -m gevent.tests \
#		-uall,-network \
#		--config known_failures.py \
#		--ignore tests_that_dont_use_resolver.txt || die
#	GEVENT_RESOLVER=thread \
#		"${EPYTHON}" -m gevent.tests \
#		--verbose \
#		-uall,-network \
#		--config known_failures.py \
#		--ignore tests_that_dont_use_resolver.txt || die
	GEVENT_FILE=thread \
		"${EPYTHON}" -m gevent.tests \
		--verbose \
		-uall,-network \
		--config known_failures.py \
		test__*subprocess*.py || die
}

python_install_all() {
	local DOCS=( AUTHORS README.rst )
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
