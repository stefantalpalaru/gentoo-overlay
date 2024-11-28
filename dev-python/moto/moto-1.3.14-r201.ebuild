# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Mock library for boto"
HOMEPAGE="https://github.com/spulec/moto"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/aws-xray-sdk-0.93:python2[${PYTHON_USEDEP}]
	>=dev-python/boto-2.36.0:python2[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.9.201:python2[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.12.201:python2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.3.0:python2[${PYTHON_USEDEP}]
	>=dev-python/docker-2.5.1:python2[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5:python2[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.10.1:python2[${PYTHON_USEDEP}]
	>=dev-python/jsondiff-1.1.2:python2[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5:python2[${PYTHON_USEDEP}]
	>=dev-python/responses-0.9.0:python2[${PYTHON_USEDEP}]
	>dev-python/six-1.9:python2[${PYTHON_USEDEP}]
	dev-python/backports-tempfile:python2[${PYTHON_USEDEP}]
	dev-python/cfn-lint:python2[${PYTHON_USEDEP}]
	dev-python/cookies:python2[${PYTHON_USEDEP}]
	dev-python/dicttoxml:python2[${PYTHON_USEDEP}]
	dev-python/flask:python2[${PYTHON_USEDEP}]
	dev-python/pyaml:python2[${PYTHON_USEDEP}]
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	dev-python/python-jose:python2[${PYTHON_USEDEP}]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1:python2[${PYTHON_USEDEP}]
	dev-python/werkzeug:python2[${PYTHON_USEDEP}]
	dev-python/xmltodict:python2[${PYTHON_USEDEP}]
	!<dev-python/moto-1.3.14-r3[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
			dev-python/freezegun[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]
			>=dev-python/sure-1.4.11[${PYTHON_USEDEP}]
		  )
"

python_prepare_all() {
	sed -e 's|==|>=|' \
		-i setup.py moto.egg-info/requires.txt || die

	sed -i \
		-e "s/'moto_server = moto.server:main'/'moto_server_py2 = moto.server:main'/" \
		setup.py

	# Disable tests that fail with network-sandbox.
	sed -e 's|^\(def \)\(test_context_manager()\)|\1_\2|' \
		-e 's|^\(def \)\(test_decorator_start_and_stop()\)|\1_\2|' \
		-i tests/test_core/test_decorator_calls.py || die

	# Disable tests that fail with userpriv.
	sed -e 's|^\(def \)\(test_invoke_function_from_sns()\)|\1_\2|' \
		-e 's|^\(def \)\(test_invoke_requestresponse_function()\)|\1_\2|' \
		-i tests/test_awslambda/test_lambda.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=${BUILDDIR}/lib \
		nosetests -sv ./tests || die
}
