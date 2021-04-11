# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="https://cssselect.readthedocs.io/en/latest/
	https://pypi.org/project/cssselect/
	https://github.com/scrapy/cssselect"
SRC_URI="https://github.com/scrapy/cssselect/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/lxml[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/cssselect-1.1.0-r3[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
