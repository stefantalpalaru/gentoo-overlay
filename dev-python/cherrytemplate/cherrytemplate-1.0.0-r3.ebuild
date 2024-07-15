# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="CherryTemplate"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easy and powerful templating module for Python"
HOMEPAGE="http://cherrytemplate.python-hosting.com/"
SRC_URI="https://downloads.sourceforge.net/cherrypy/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
