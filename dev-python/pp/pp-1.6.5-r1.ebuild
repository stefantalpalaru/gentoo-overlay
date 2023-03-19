# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Parallel and distributed programming for Python"
HOMEPAGE="https://www.parallelpython.com/"
SRC_URI="https://ftp.kaist.ac.kr/macports/distfiles/py-pp/pp-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

python_install_all() {
	doman doc/ppserver.1
	use doc && HTML_DOCS=( doc/ppdoc.html )

	if use examples; then
		docinto /usr/share/doc/${PF}
		dodoc -r "${S}/examples"
	fi
	distutils-r1_python_install_all
}
