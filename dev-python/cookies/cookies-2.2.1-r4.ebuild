# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Friendlier RFC 6265-compliant cookie parser/renderer"
HOMEPAGE="https://gitlab.com/sashahart/cookies"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/cookies-2.2.1-r3[${PYTHON_USEDEP}]
"

PATCHES=(
	# https://gitlab.com/sashahart/cookies/merge_requests/2
	"${FILESDIR}/cookies-2.2.1-fix-warnings.patch"

	"${FILESDIR}/cookies-2.2.1-tests.patch"
)
