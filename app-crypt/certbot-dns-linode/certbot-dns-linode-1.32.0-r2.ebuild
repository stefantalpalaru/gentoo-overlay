# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=(python3_{10..12}) # we're limited by what dns-lexicon supports, here
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Linode DNS Authenticator plugin for Certbot"
HOMEPAGE="https://github.com/certbot/certbot/tree/master/certbot-dns-linode"
SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> certbot-${PV}.tar.gz"
S="${WORKDIR}/certbot-${PV}/${PN}"
LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	>=app-crypt/acme-${PV}:0/1[${PYTHON_USEDEP}]
	>=app-crypt/certbot-${PV}:0/1[${PYTHON_USEDEP}]
	>=dev-python/dns-lexicon-3.2.1:0[${PYTHON_USEDEP}]
"
