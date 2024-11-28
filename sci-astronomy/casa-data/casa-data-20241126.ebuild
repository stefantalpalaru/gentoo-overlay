# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data and tables for the CASA software"
HOMEPAGE="https://github.com/casacore/casacore/"
SRC_URI="ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures_${PV}-160001.ztar -> ${P}.tar.Z"
S="${WORKDIR}"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

src_install(){
	insinto /usr/share/casa/data
	doins -r *
}
