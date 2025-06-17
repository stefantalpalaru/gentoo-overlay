# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Backport of the selectors module from Python 3.4"
HOMEPAGE="https://github.com/berkerpeksag/selectors34"
LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
