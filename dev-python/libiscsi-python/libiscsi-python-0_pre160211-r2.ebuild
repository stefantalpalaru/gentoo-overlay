# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

HASH="a8f548c2700dbe3dadfe048fa2491c7b77cf7846"

DESCRIPTION="Python bindings for libiscsi"
HOMEPAGE="https://github.com/sahlberg/libiscsi-python"
SRC_URI="https://github.com/sahlberg/libiscsi-python/archive/${HASH}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${HASH}
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="net-libs/libiscsi"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
