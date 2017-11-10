# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1 git-r3

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"
#SRC_URI="https://github.com/python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# the "typeshed" git submodule is not included in the GitHub archives
# so we might as well use Git for everything
EGIT_REPO_URI="https://github.com/python/${PN}"
EGIT_COMMIT="v${PV}"

LICENSE="MIT PSF-2 PYTHON"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	doc? (
		>=dev-python/sphinx-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-0.1.9[${PYTHON_USEDEP}]
	)
"
RDEPEND="$(python_gen_cond_dep '>=dev-python/typing-3.5.3[${PYTHON_USEDEP}]' 'python3_4')
	>=dev-python/psutil-5.4.0
	<dev-python/psutil-5.5.0
	>=dev-python/typed-ast-1.1.0
	<dev-python/typed-ast-1.2.0
"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
