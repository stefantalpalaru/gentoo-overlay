# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
# Set to 'manual' to avoid triggering install QA check
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools
		https://pypi.org/project/setuptools/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

BDEPEND="
	app-arch/unzip
"
# installing plugins apparently breaks stuff at runtime, so let's pull
# it early
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
"
RDEPEND="
	!<dev-python/setuptools-44.1.1-r200[${PYTHON_USEDEP}]
"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst docs/{easy_install.txt,pkg_resources.txt,setuptools.txt} )

python_prepare_all() {
	# silence the py2 warning that is awfully verbose and breaks some
	# packages by adding unexpected output
	# (also, we know!)
	sed -i -e '/py2_warn/d' pkg_resources/__init__.py || die

	# disable tests requiring a network connection
	rm setuptools/tests/test_packageindex.py || die

	# don't run integration tests
	rm setuptools/tests/test_integration.py || die

	# xpass-es for me on py3
	sed -e '/xfail.*710/s:(:(six.PY2, :' \
		-i setuptools/tests/test_archive_util.py || die

	# avoid pointless dep on flake8
	sed -i -e 's:--flake8::' pytest.ini || die

	sed -i \
		-e 's/yield "easy_install = setuptools.command.easy_install:main"/yield "easy_install_py2 = setuptools.command.easy_install:main"/' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}
