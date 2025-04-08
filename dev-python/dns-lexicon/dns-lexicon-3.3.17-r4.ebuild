# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Manipulate DNS records on various DNS providers in a standardized/agnostic way"
HOMEPAGE="https://pypi.org/project/dns-lexicon/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tldextract[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	!<dev-python/dns-lexicon-3.3.17-r2[${PYTHON_USEDEP}]
"
