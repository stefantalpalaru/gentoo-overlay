# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
MY_P="Paste-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"

inherit distutils-r1 pypi

DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="https://pypi.org/project/Paste/"
S=${WORKDIR}/${MY_P}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror test"

RDEPEND="
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	!<dev-python/paste-3.5.0-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs

python_prepare_all() {
	# TODO: 'Address already in use'
	sed -e 's:test_address_family_v4:_&:' \
		-i tests/test_httpserver.py || die

	# Remove a test that runs against the paste website.
	rm -f tests/test_proxy.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
