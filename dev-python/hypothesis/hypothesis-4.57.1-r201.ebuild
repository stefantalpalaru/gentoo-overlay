# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 optfeature

DESCRIPTION="A library for property based testing"
HOMEPAGE="https://github.com/HypothesisWorks/hypothesis
	https://pypi.org/project/hypothesis/"
SRC_URI="https://github.com/HypothesisWorks/${PN}/archive/${PN}-python-${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${PN}-python-${PV}/${PN}-python"
LICENSE="MPL-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/enum34[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	!<dev-python/hypothesis-4.57.1-r1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		!<dev-python/typing-3.7.4.1
	)
"

src_prepare() {
	# avoid pytest-xdist dep for one test
	sed -i -e 's:test_prints_statistics_given_option_under_xdist:_&:' \
		tests/pytest/test_statistics.py || die
	distutils-r1_src_prepare
}

python_test() {
	local pyver=$(python_is_python3 && echo 3 || echo 2)
	pytest -vv tests/cover tests/pytest tests/py${pyver} ||
		die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "datetime support" dev-python/pytz
	optfeature "dateutil support" dev-python/python-dateutil
	optfeature "numpy support" dev-python/numpy
	optfeature "django support" dev-python/django dev-python/pytz
	optfeature "pandas support" dev-python/pandas
	optfeature "pytest support" dev-python/pytest
}
