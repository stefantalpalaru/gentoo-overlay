# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
# 0.1.1 isn't tagged on GitHub
COMMIT_HASH="ee3dcca0df300e0584e129a4ab81828be002684b"
MY_PN="${PN//-/_}"
MY_P="${MY_PN}-${PV}"
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Pure python RFC3986 validator"
HOMEPAGE="https://pypi.org/project/rfc3986-validator/
		https://github.com/naimetti/rfc3986-validator"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"
RESTRICT="mirror test"

RDEPEND="dev-python/rfc3987[${PYTHON_USEDEP}]
	!<dev-python/rfc3986-validator-0.1.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# remove dep on pytest-runner
	sed -i -r "s:('|\")pytest-runner('|\")(,|)::" setup.py || die
	distutils-r1_python_prepare_all
}
