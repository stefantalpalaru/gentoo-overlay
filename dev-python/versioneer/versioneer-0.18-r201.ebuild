# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Easy VCS-based management of project version strings"
HOMEPAGE="https://pypi.org/project/versioneer/
		https://github.com/warner/python-versioneer"
LICENSE="public-domain"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	!<dev-python/versioneer-0.18-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/versioneer = versioneer:main/versioneer_py2 = versioneer:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
