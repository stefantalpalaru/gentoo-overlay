# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Sphinx theme integrates the Bootstrap CSS / JavaScript framework"
HOMEPAGE="https://ryan-roemer.github.io/sphinx-bootstrap-theme/README.html
		https://github.com/ryan-roemer/sphinx-bootstrap-theme"
# Latest version isn't on PyPI
# https://github.com/ryan-roemer/sphinx-bootstrap-theme/issues/210
SRC_URI="https://github.com/ryan-roemer/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/sphinx-bootstrap-theme-0.8.0-r200[${PYTHON_USEDEP}]
"
