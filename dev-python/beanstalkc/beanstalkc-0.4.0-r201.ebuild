# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A simple beanstalkd client library"
HOMEPAGE="https://github.com/earl/beanstalkc
		https://pypi.org/project/beanstalkc/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	!<dev-python/beanstalkc-0.4.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
