# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="python classes generated from the common protos in the googleapis repository"
HOMEPAGE="https://pypi.org/project/googleapis-common-protos/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/protobuf[${PYTHON_USEDEP}]
	!<dev-python/googleapis-common-protos-1.51.0-r200[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}

# no tests as this is all generated code
