# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="ClientCookie-${PV}"

DESCRIPTION="Python module for handling HTTP cookies on the client side"
HOMEPAGE="http://wwwsearch.sourceforge.net/ClientCookie/
	https://pypi.org/project/ClientCookie/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/clientcookie/${PV}-1/clientcookie_${PV}.orig.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS="*.txt"
