# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit python-r1 toolchain-funcs

DESCRIPTION="Private sip module for PyQt5"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/intro"

MY_PN=sip
MY_P=${MY_PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
fi
S=${WORKDIR}/${MY_P}

# Sub-slot based on SIP_API_MAJOR_NR from siplib/sip.h
LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="python2/12"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	!<dev-python/pyqt5-5.12.2
	!<dev-python/pyqt5-sip-4.19.24-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	# Sub-slot sanity check
	local sub_slot=${SLOT#*/}
	local sip_api_major_nr=$(sed -nre 's:^#define SIP_API_MAJOR_NR\s+([0-9]+):\1:p' siplib/sip.h || die)
	if [[ ${sub_slot} != ${sip_api_major_nr} ]]; then
		eerror
		eerror "Ebuild sub-slot (${sub_slot}) does not match SIP_API_MAJOR_NR (${sip_api_major_nr})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${sip_api_major_nr}\""
		eerror
		die "sub-slot sanity check failed"
	fi

	default
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--sip-module PyQt5.sip
			--sysroot="${ESYSROOT}/usr"
			--no-tools
			AR="$(tc-getAR) cqs"
			CC="$(tc-getCC)"
			CFLAGS="${CFLAGS}"
			CFLAGS_RELEASE=
			CXX="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CXXFLAGS_RELEASE=
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			LFLAGS="${LDFLAGS}"
			LFLAGS_RELEASE=
			RANLIB=
			STRIP=
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation

	einstalldocs
}
