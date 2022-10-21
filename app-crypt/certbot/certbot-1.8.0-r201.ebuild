# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Let's encrypt client to automate deployment of X.509 certificates"
HOMEPAGE="https://github.com/certbot/certbot
		https://letsencrypt.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
S=${WORKDIR}/${P}/${PN}
LICENSE="Apache-2.0"
SLOT="python2"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-crypt/acme-1.6.0:python2[${PYTHON_USEDEP}]
	>=dev-python/ConfigArgParse-0.9.3:python2[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.8[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.1.0[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-1.3[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	!<app-crypt/certbot-1.8.0-r2[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# required as deps of deps can trigger this too...
	echo '    ignore:.*collections\.abc:DeprecationWarning' >> ../pytest.ini

	sed -i \
		-e 's/certbot = certbot.main:main/certbot_py2 = certbot.main:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
