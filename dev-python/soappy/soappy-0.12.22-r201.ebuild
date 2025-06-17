# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl?,xml"
MY_PN="SOAPpy"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1 pypi

DESCRIPTION="SOAP Services for Python"
HOMEPAGE="http://pywebsvcs.sourceforge.net/
		https://pypi.org/project/SOAPpy/"
SRC_URI="$(pypi_sdist_url --no-normalize SOAPpy "${PV}" .zip)"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples ssl"
RESTRICT="mirror"

RDEPEND="dev-python/wstools:python2[${PYTHON_USEDEP}]
	dev-python/defusedxml:python2[${PYTHON_USEDEP}]
	ssl? ( dev-python/m2crypto:python2[${PYTHON_USEDEP}] )
	!<dev-python/soappy-0.12.22-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( CHANGES.txt README.txt docs/. )

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r bid contrib tools validate
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
