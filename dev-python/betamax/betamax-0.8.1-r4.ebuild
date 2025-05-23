# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="python-requests HTTP exchanges recorder"
HOMEPAGE="https://github.com/betamaxpy/betamax"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="dev-python/requests:python2[${PYTHON_USEDEP}]
	!<dev-python/betamax-0.8.1-r3[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/betamax-0.8.1-tests.patch"
)

src_prepare() {
	rm tests/integration/test_hooks.py || die
	rm tests/integration/test_placeholders.py || die
	sed -e 's:test_records:_&:' \
		-e 's:test_replaces:_&:' \
		-e 's:test_replays:_&:' \
		-e 's:test_creates:_&:' \
		-i tests/integration/test_record_modes.py || die
	rm tests/integration/test_unicode.py || die
	rm tests/regression/test_gzip_compression.py || die
	rm tests/regression/test_requests_2_11_body_matcher.py || die
	distutils-r1_src_prepare
}
