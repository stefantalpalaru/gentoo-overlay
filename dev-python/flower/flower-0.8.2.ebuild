# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Flower is a web based tool for monitoring and administrating Celery clusters."
HOMEPAGE="https://github.com/mher/flower https://pypi.python.org/pypi/flower/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
		dev-python/Babel[${PYTHON_USEDEP}]
		dev-python/celery[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.0.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
