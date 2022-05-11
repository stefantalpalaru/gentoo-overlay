# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DVB firmware from the LibreELEC project"
HOMEPAGE="https://github.com/CoreELEC/dvb-firmware"
if [[ ${PV} = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CoreELEC/dvb-firmware.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/CoreELEC/dvb-firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="all-rights-reserved freedist ISC"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# delete files already in sys-kernel/linux-firmware
	local files_colliding=(
		LICENCE.go7007
		LICENCE.siano
		LICENCE.xc5000
		LICENSE.dib0700
		as102_data1_st.hex
		as102_data2_st.hex
		cmmb_vega_12mhz.inp
		cmmb_venice_12mhz.inp
		dvb-fe-xc4000-1.4.1.fw
		dvb-fe-xc5000-1.6.114.fw
		dvb-fe-xc5000c-4.1.30.7.fw
		dvb-usb-dib0700-1.20.fw
		dvb-usb-it9135-01.fw
		dvb-usb-it9135-02.fw
		dvb-usb-terratec-h5-drxk.fw
		dvb_nova_12mhz.inp
		dvb_nova_12mhz_b0.inp
		go7007
		isdbt_nova_12mhz.inp
		isdbt_nova_12mhz_b0.inp
		isdbt_rio.inp
		lgs8g75.fw
		s2250.fw
		s2250_loader.fw
		sms1xxx-hcw-55xxx-dvbt-02.fw
		sms1xxx-hcw-55xxx-isdbt-02.fw
		sms1xxx-nova-a-dvbt-01.fw
		sms1xxx-nova-b-dvbt-01.fw
		sms1xxx-stellar-dvbt-01.fw
		tdmb_nova_12mhz.inp
		tlg2300_firmware.bin
		ttusb-budget
		v4l-cx231xx-avcore-01.fw
		v4l-cx23418-apu.fw
		v4l-cx23418-cpu.fw
		v4l-cx23418-dig.fw
		v4l-cx23885-avcore-01.fw
		v4l-cx25840.fw
	)
	for f in "${files_colliding[@]}"; do
		rm -rf "firmware/${f}"
	done
}

src_install() {
	insinto /lib/firmware
	doins -r firmware/*
}
