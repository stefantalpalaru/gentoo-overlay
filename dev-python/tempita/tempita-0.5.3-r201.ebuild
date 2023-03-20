# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Tempita"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A very small text templating language"
HOMEPAGE="https://pypi.org/project/Tempita/"
# Tests are not published on PyPI
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}dev.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	!<dev-python/tempita-0.5.3-r200[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}dev"
