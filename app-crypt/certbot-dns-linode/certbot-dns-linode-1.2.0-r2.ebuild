# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python2_7 python3_{8..9})
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Linode DNS Authenticator plugin for Certbot"
HOMEPAGE="https://github.com/certbot/certbot/tree/master/certbot-dns-linode"
SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> certbot-${PV}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '>=app-crypt/acme-0.21.1:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep '>=app-crypt/acme-0.21.1:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep '>=app-crypt/certbot-0.21.1:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep '>=app-crypt/certbot-0.21.1:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep '>=dev-python/dns-lexicon-2.2.1:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep '>=dev-python/dns-lexicon-2.2.1:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep 'dev-python/mock:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/mock:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep 'dev-python/zope-interface:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/zope-interface:0[${PYTHON_USEDEP}]' -3)
"

S="${WORKDIR}/certbot-${PV}/${PN}"
