# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Pure Python PNG image encoder/decoder"
HOMEPAGE="https://github.com/drj11/pypng https://pypi.org/project/pypng/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	!<dev-python/pypng-0.0.20-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	for SCRIPT in prichunkpng priforgepng prigreypng pripalpng pripamtopng pripnglsch pripngtopam priweavepng; do
		mv "code/${SCRIPT}" "code/${SCRIPT}_py2"
		sed -i \
			-e "s#code/${SCRIPT}#code/${SCRIPT}_py2#" \
			setup.py || die
	done
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" code/test_png.py -v || die "Tests fail with ${EPYTHON}"
}
