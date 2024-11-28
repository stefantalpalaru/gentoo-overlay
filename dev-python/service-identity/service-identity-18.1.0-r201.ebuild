# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Service identity verification for pyOpenSSL"
HOMEPAGE="https://github.com/pyca/service-identity"
SRC_URI="https://github.com/pyca/service-identity/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${P/_/-}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

# TODO: upstream made pyopenssl optional
RDEPEND="
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	!<dev-python/service-identity-18.1.0-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
