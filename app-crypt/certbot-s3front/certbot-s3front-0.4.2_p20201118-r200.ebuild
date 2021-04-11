# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit git-r3 distutils-r1

DESCRIPTION="S3/CloudFront plugin for Let's Encrypt client"
HOMEPAGE="https://github.com/dlapiduz/letsencrypt-s3front"
EGIT_REPO_URI="https://github.com/dlapiduz/certbot-s3front"
EGIT_COMMIT="3344e55cfbc1f289c328c98c90360ac7e51aaa20"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=app-crypt/acme-0.1.1:python2[${PYTHON_USEDEP}]
	>=app-crypt/certbot-0.9.3:python2[${PYTHON_USEDEP}]
	dev-python/boto3:python2[${PYTHON_USEDEP}]
	dev-python/mock:python2[${PYTHON_USEDEP}]
	dev-python/pyopenssl:python2[${PYTHON_USEDEP}]
	dev-python/zope-interface:python2[${PYTHON_USEDEP}]
	!<dev-python/certbot-s3front-0.4.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
