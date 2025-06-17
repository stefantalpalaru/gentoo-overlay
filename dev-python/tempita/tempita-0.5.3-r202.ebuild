# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="Tempita"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1 pypi

DESCRIPTION="A very small text templating language"
HOMEPAGE="https://pypi.org/project/Tempita/"
# Tests are not published on PyPI
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}" "${PV}dev")"
S="${WORKDIR}/${MY_P}dev"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	!<dev-python/tempita-0.5.3-r200[${PYTHON_USEDEP}]
"
