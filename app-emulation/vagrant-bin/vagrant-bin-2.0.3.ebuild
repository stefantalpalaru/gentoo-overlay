# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/-bin/}
inherit unpacker eutils

DESCRIPTION="Tool for building and distributing virtual machines"
HOMEPAGE="http://vagrantup.com/"

SRC_URI="
	amd64? ( "https://releases.hashicorp.com/vagrant/${PV}/vagrant_${PV}_x86_64.deb" )
	x86? ( "https://releases.hashicorp.com/vagrant/${PV}/vagrant_${PV}_i686.deb" )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/opt/${MY_PN}"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/libarchive
	net-misc/curl
	!app-emulation/vagrant
"

RESTRICT="mirror"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default
	sed -i 's/cached: true/cached: false/g' ./embedded/gems/${PV}/gems/${MY_PN}-${PV}/plugins/provisioners/chef/provisioner/chef_solo.rb || die
}

src_install() {
	local dir="/opt/${MY_PN}"
	dodir ${dir}
	cp -ar ./* "${ED}${dir}" || die "copy files failed"

	make_wrapper "${MY_PN}" "${dir}/bin/${MY_PN}"
}
