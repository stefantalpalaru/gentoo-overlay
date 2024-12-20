# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Core common functionality of Jupyter projects"
HOMEPAGE="https://jupyter.org
		https://github.com/jupyter/jupyter_core"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/traitlets:python2[${PYTHON_USEDEP}]
	!<dev-python/jupyter-core-4.6.3-r3[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-github-alt[${PYTHON_USEDEP}] )
	test? (
		>=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die
	fi

	sed -i \
		-e 's/jupyter              = jupyter_core.command:main/jupyter_py2              = jupyter_core.command:main/' \
		-e 's/jupyter-migrate      = jupyter_core.migrate:main/jupyter-migrate_py2      = jupyter_core.migrate:main/' \
		-e 's/jupyter-troubleshoot = jupyter_core.troubleshoot:main/jupyter-troubleshoot_py2 = jupyter_core.troubleshoot:main/' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	py.test jupyter_core || die
}
