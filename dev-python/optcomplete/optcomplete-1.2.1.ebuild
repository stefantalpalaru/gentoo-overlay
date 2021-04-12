# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
MY_COMMIT="7b7af9d2bfcd9649c301372bab055e3bbaad7370"

inherit distutils-r1

DESCRIPTION="Shell completion self-generator for Python"
HOMEPAGE="https://github.com/blais/optcomplete
	https://pypi.org/project/optcomplete/"
SRC_URI="https://github.com/blais/optcomplete/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-linux"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_COMMIT}"

python_install_all() {
	use examples && local EXAMPLES=( bin/. )
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
