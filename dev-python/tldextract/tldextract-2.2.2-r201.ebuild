# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Accurately separate the TLD from the registered domain and subdomains of a URL."
HOMEPAGE="https://pypi.org/project/tldextract/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-file[${PYTHON_USEDEP}]
	!<dev-python/tldextract-2.2.2-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/'tldextract = tldextract.cli:main'/'tldextract_py2 = tldextract.cli:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}
