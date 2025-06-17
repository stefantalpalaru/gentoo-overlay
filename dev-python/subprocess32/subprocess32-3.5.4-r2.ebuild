# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="A backport of the subprocess module from Python 3.2/3.3 for use on 2.x"
HOMEPAGE="https://github.com/google/python-subprocess32"
LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ppc ppc64 ~sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

python_test() {
	"${PYTHON}" test_subprocess32.py || die "Tests fail with ${EPYTHON}"
}
