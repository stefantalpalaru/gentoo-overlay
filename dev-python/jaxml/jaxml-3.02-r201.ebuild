# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="XML generator written in Python"
HOMEPAGE="http://www.librelogiciel.com/software/jaxml/action_Presentation
		https://pypi.org/project/jaxml/"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="amd64 hppa ppc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/jaxml-3.02-r200[${PYTHON_USEDEP}]
"
