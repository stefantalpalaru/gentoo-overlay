# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Library to manage python plugins/extensions"
HOMEPAGE="https://github.com/magmax/python-pluginloader"
SRC_URI="https://github.com/magmax/python-pluginloader/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	${PYTHON_DEPS}
	!<dev-python/python-pluginloader-1.0.0-r200[${PYTHON_USEDEP}]
"
