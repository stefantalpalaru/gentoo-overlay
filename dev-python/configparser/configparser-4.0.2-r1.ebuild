# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Backport of Python-3 built-in configparser"
HOMEPAGE="https://pypi.org/project/configparser/
		https://github.com/jaraco/configparser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_install() {
	# avoid a collision with dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build

	find "${D}" -name '*.pth' -delete || die
}
