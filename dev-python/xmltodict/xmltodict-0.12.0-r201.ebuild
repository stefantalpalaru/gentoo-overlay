# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Makes working with XML feel like you are working with JSON"
HOMEPAGE="https://github.com/martinblech/xmltodict/
		https://pypi.org/project/xmltodict/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT="mirror"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/xmltodict-0.12.0-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
