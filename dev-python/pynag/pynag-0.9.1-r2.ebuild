# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python modules for Nagios plugins and configuration"
HOMEPAGE="http://pynag.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="test? ( dev-python/unittest2[${PYTHON_USEDEP}] )"
