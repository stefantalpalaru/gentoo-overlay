# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Pure Python PNG image encoder/decoder"
HOMEPAGE="https://github.com/drj11/pypng https://pypi.org/project/pypng/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT="mirror"

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
