# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Replacement for the existing standard pip's requirements.txt file"
HOMEPAGE="https://github.com/pypa/pipfile"
SRC_URI="https://github.com/pypa/pipfile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"

RDEPEND="dev-python/toml[${PYTHON_USEDEP}]
	!<dev-python/pipfile-0.0.2-r200[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
