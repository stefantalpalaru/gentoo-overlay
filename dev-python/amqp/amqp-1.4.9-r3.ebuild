# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="https://github.com/celery/py-amqp
	https://pypi.org/project/amqp/"
LICENSE="LGPL-3"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc examples extras test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-python/amqp-1.4.9-r2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-issuetracker-0.9[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

# Same tests from before require a socket connection
PATCHES=( "${FILESDIR}"/py-amqp-1.3.3-disable_socket_tests.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cp -r -l funtests "${BUILD_DIR}"/lib/ || die
	cd "${BUILD_DIR}"/lib || die
	if [[ ${EPYTHON:6:1} == 3 ]]; then
		#   -n causes Python to write into hardlinked files
		2to3 --no-diffs -w funtests || die
	fi
	"${PYTHON}" funtests/run_all.py || die "Tests failed under ${EPYTHON}"
	rm -rf funtests/ || die
}

python_install_all() {
	use examples && local EXAMPLES=( demo/. )
	use doc && local HTML_DOCS=( docs/.build/html/. )
	if use extras; then
		insinto /usr/share/${PF}/extras
		doins -r extra
	fi
	distutils-r1_python_install_all
}
