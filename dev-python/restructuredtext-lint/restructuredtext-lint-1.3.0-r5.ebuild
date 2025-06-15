# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-/_}"
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Checks PyPI validity of reStructuredText"
HOMEPAGE="https://pypi.org/project/restructuredtext_lint/"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="Unlicense"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	<dev-python/docutils-1.0[${PYTHON_USEDEP}]
	!<dev-python/restructuredtext-lint-1.3.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/'restructuredtext-lint = restructuredtext_lint.cli:main'/'restructuredtext-lint_py2 = restructuredtext_lint.cli:main'/" \
		-e "s/'rst-lint = restructuredtext_lint.cli:main'/'rst-lint_py2 = restructuredtext_lint.cli:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	 nosetests -v || die
}
