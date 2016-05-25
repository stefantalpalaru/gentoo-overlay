# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7)

EGIT_REPO_URI="https://github.com/dlapiduz/letsencrypt-s3front"

inherit git-r3 distutils-r1

DESCRIPTION="S3/CloudFront plugin for Let's Encrypt client"
HOMEPAGE="https://github.com/dlapiduz/letsencrypt-s3front"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=app-crypt/acme-0.1.1[${PYTHON_USEDEP}]
	app-crypt/certbot[${PYTHON_USEDEP}]
	dev-python/boto3
	>=dev-python/pyparsing-1.5.5[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
