# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Accurately separate the TLD from the registered domain and subdomains of a URL"
HOMEPAGE="https://github.com/john-kurkowski/tldextract"
SRC_URI="https://github.com/john-kurkowski/tldextract/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-file-1.4[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
