# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )
MY_COMMIT="3344e55cfbc1f289c328c98c90360ac7e51aaa20"

inherit distutils-r1

DESCRIPTION="S3/CloudFront plugin for Let's Encrypt client"
HOMEPAGE="https://github.com/dlapiduz/letsencrypt-s3front"
SRC_URI="https://github.com/dlapiduz/certbot-s3front/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/certbot-s3front-${MY_COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-crypt/acme-0.1.1:0/1[${PYTHON_USEDEP}]
	>=app-crypt/certbot-0.9.3:0/1[${PYTHON_USEDEP}]
	dev-python/boto3:0[${PYTHON_USEDEP}]
	dev-python/mock:0[${PYTHON_USEDEP}]
	dev-python/pyopenssl:0[${PYTHON_USEDEP}]
	dev-python/zope-interface:0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
