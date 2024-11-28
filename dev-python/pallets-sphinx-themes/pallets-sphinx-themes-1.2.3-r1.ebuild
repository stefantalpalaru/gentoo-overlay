# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Sphinx themes for Pallets and related projects"
HOMEPAGE="https://github.com/pallets/pallets-sphinx-themes"
SRC_URI="https://github.com/pallets/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86"

RDEPEND="dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	!<dev-python/pallets-sphinx-themes-1.2.3[${PYTHON_USEDEP}]
"
