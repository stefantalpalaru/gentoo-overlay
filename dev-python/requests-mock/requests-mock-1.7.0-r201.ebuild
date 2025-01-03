# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Mock out responses from the requests package"
HOMEPAGE="https://github.com/jamielennox/requests-mock"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/python-subunit[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/requests-2.3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/requests-mock-1.7.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# Disable reno which only works inside a git repository
	# Disable intersphinx
	sed -i -e "s/'reno.sphinxext',//" \
		-e "s/'sphinx.ext.intersphinx'//" \
		doc/source/conf.py || die
	# Remove the release notes section which requires reno
	rm doc/source/release-notes.rst || die
	sed -i '/^=============$/,/release-notes/d' doc/source/index.rst || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build doc/source docs/source/build/_html || die
		HTML_DOCS=( docs/source/build/_html/. )
	fi
}

python_test() {
	rm -rf .testrepository \
		|| die "couldn't remove '.testrepository' under ${EPYTHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}
