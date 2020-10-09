# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="A Python package for creating beautiful command line interfaces"
SRC_URI="https://github.com/pallets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://palletsprojects.com/p/click/
		https://github.com/pallets/click
		https://pypi.org/project/click/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="examples"

distutils_enable_sphinx docs \
	'>=dev-python/docutils-0.14' \
	dev-python/pallets-sphinx-themes

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
