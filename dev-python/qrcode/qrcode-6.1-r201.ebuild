# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="QR Code generator on top of PIL"
HOMEPAGE="https://pypi.org/project/qrcode/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 ~x86"
RESTRICT="mirror test"

# optional deps:
# - pillow and lxml for svg backend, set as hard deps
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	!<dev-python/qrcode-6.1-r1[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i \
		-e 's/qr = qrcode.console_scripts:main/qr_py2 = qrcode.console_scripts:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install
	doman doc/qr.1
}
