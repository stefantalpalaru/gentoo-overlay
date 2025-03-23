# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi

DESCRIPTION="A screamingly fast Python WSGI server written in C"
HOMEPAGE="https://github.com/jonashaag/bjoern
		https://pypi.org/project/bjoern/"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-libs/libev
	net-libs/http-parser"
RDEPEND="${DEPEND}"
