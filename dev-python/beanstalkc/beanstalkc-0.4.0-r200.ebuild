# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A simple beanstalkd client library"
HOMEPAGE="https://github.com/earl/beanstalkc https://pypi.org/project/beanstalkc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	!<dev-python/beanstalkc-0.4.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
