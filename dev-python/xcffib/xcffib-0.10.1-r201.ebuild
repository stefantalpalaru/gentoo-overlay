# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A drop in replacement for xpyb, an XCB python binding"
HOMEPAGE="https://github.com/tych0/xcffib"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"
RESTRICT="mirror"

DEPEND="x11-libs/libxcb"
RDEPEND="
	${DEPEND}
	>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/xcffib-0.10.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		x11-base/xorg-server[xvfb]
		x11-apps/xeyes
	)"

distutils_enable_tests nose
