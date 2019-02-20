# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python2_7)

inherit git-r3 distutils-r1

DESCRIPTION="S3/CloudFront plugin for Let's Encrypt client"
HOMEPAGE="https://github.com/dlapiduz/letsencrypt-s3front"
EGIT_REPO_URI="https://github.com/dlapiduz/certbot-s3front"
EGIT_COMMIT="010eb1dc46508c3d166022c067d5094907a3c5c0"

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
