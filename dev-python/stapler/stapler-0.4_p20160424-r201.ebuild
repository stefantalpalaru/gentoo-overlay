# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

# Commit Date: 26th Apr 2016
COMMIT="7c153e6a8f52573ff886ebf0786b64e17699443a"

DESCRIPTION="Suite of tools for PDF files manipulation written in Python"
HOMEPAGE="https://github.com/hellerbarde/stapler"
SRC_URI="https://github.com/hellerbarde/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/PyPDF2:python2[${PYTHON_USEDEP}]
	dev-python/more-itertools:python2[${PYTHON_USEDEP}]
	!<dev-python/stapler-0.4_p20160424-r200[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i \
		-e 's/stapler = staplelib:main/stapler_py2 = staplelib:main/' \
		-e 's/pdf-stapler = staplelib:main/pdf-stapler_py2 = staplelib:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
