# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python2_7)

inherit git-r3 distutils-r1

DESCRIPTION="S3/CloudFront plugin for Let's Encrypt client"
HOMEPAGE="https://github.com/dlapiduz/letsencrypt-s3front"
EGIT_REPO_URI="https://github.com/dlapiduz/certbot-s3front"
EGIT_COMMIT="2ce0a2fe1c96647c196e6602116410264d023fab"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=app-crypt/acme-0.1.1[${PYTHON_USEDEP}]
	>=app-crypt/certbot-0.9.3[${PYTHON_USEDEP}]
	dev-python/boto3
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
