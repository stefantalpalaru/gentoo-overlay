# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"

inherit distutils-r1 pypi

MY_PN="Cheetah"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Python-powered template engine and code generator"
HOMEPAGE="http://www.cheetahtemplate.org/
	https://rtyler.github.com/cheetah/
	https://pypi.org/project/Cheetah/
	https://github.com/cheetahtemplate/cheetah"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="mirror"

RDEPEND="dev-python/markdown:python2[${PYTHON_USEDEP}]
	!dev-python/cheetah3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( CHANGES README.markdown TODO )
# Race in the test suite
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Disable broken tests.
	sed \
		-e "/Unicode/d" \
		-e "s/if not sys.platform.startswith('java'):/if False:/" \
		-e "/results =/a\\    sys.exit(not results.wasSuccessful())" \
		-i cheetah/Tests/Test.py || die "sed failed"

	for script in bin/*; do
		mv "${script}" "${script}_py2"
	done
	sed -i \
		-e "s%'bin/cheetah-compile'%'bin/cheetah-compile_py2'%" \
		-e "s%'bin/cheetah'%'bin/cheetah_py2'%" \
		-e "s%'bin/cheetah-analyze'%'bin/cheetah-analyze_py2'%" \
		SetupConfig.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" cheetah/Tests/Test.py || die "Testing failed with ${EPYTHON}"
}
