# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit autotools python-r1

DESCRIPTION="a ptracing profiler for Python"
HOMEPAGE="https://github.com/uber/pyflame http://pyflame.readthedocs.org/"
SRC_URI="https://github.com/uber/pyflame/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default
	sed -i -e 's/python2/python-2.7/' configure.ac || die

	[[ ${PYTHON_TARGETS} == *python2_7* ]] || sed -i -e 's/enable_py26="yes"/enable_py26="no"/' configure.ac
	[[ ${PYTHON_TARGETS} == *python3_4* ]] || [[ ${PYTHON_TARGETS} == *python3_5* ]] || sed -i -e 's/enable_py34="yes"/enable_py34="no"/' configure.ac
	[[ ${PYTHON_TARGETS} == *python3_6* ]] || sed -i -e 's/enable_py36="yes"/enable_py36="no"/' configure.ac

	eautoreconf
}

src_install() {
	default
	dobin utils/flame-chart-json
}
