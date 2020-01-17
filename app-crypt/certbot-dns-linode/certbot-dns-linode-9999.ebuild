# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python{2_7,3_6,3_7})

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	inherit git-r3
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> certbot-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/certbot-${PV}/${PN}"
fi

inherit distutils-r1

DESCRIPTION="Linode DNS Authenticator plugin for Certbot"
HOMEPAGE="https://github.com/certbot/certbot/tree/master/certbot-dns-linode"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=app-crypt/acme-0.21.1[${PYTHON_USEDEP}]
	>=app-crypt/certbot-0.21.1[${PYTHON_USEDEP}]
	>=dev-python/dns-lexicon-2.2.1[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
