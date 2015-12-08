# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="vendor and platform neutral SDR support library"
HOMEPAGE="http://github.com/pothosware/SoapySDR"
SRC_URI="https://github.com/pothosware/SoapySDR/tarball/soapy-sdr-$PV -> $P.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig:0 )
"

src_unpack() {
	unpack ${A}
	mv *-SoapySDR-* "${S}"
}

pkg_setup() {
	mycmakeargs=(
		$(cmake-utils_use_enable python PYTHON)
	)
	use python && python-single-r1_pkg_setup
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize
}
