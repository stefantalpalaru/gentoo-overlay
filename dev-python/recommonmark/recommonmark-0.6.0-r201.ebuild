# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python docutils-compatibility bridge to CommonMark"
HOMEPAGE="https://recommonmark.readthedocs.io/
		https://github.com/readthedocs/recommonmark"
SRC_URI="https://github.com/readthedocs/recommonmark/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	>=dev-python/commonmark-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
	!<dev-python/recommonmark-0.6.0-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	# known broken with new sphinx
	# https://github.com/readthedocs/recommonmark/issues/164
	sed -e 's:test_lists:_&:' \
		-e '/CustomExtensionTests/s:SphinxIntegrationTests:object:' \
		-i tests/test_sphinx.py || die

	sed -i \
		-e 's/cm2html = recommonmark.scripts:cm2html/cm2html_py2 = recommonmark.scripts:cm2html/' \
		-e 's/cm2latex = recommonmark.scripts:cm2latex/cm2latex_py2 = recommonmark.scripts:cm2latex/' \
		-e 's/cm2man = recommonmark.scripts:cm2man/cm2man_py2 = recommonmark.scripts:cm2man/' \
		-e 's/cm2pseudoxml = recommonmark.scripts:cm2pseudoxml/cm2pseudoxml_py2 = recommonmark.scripts:cm2pseudoxml/' \
		-e 's/cm2xetex = recommonmark.scripts:cm2xetex/cm2xetex_py2 = recommonmark.scripts:cm2xetex/' \
		-e 's/cm2xml = recommonmark.scripts:cm2xml/cm2xml_py2 = recommonmark.scripts:cm2xml/' \
		setup.py || die

	distutils-r1_src_prepare
}
