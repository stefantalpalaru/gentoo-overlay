# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
MY_COMMIT="2129abf060eb6af45e0393135da24736e363fc9b"

inherit python-single-r1

DESCRIPTION="Create and run optimised Windows, macOS and Linux desktop virtual machines"
HOMEPAGE="https://github.com/quickemu-project/quickemu"
#SRC_URI="https://github.com/quickemu-project/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI="https://github.com/quickemu-project/quickemu/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/quickemu-${MY_COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror"

DEPEND="
	${PYTHON_DEPS}
	>=app-emulation/qemu-6.0.0[gtk,sdl,spice,usbredir,virtfs]
	>=app-shells/bash-4.0:=
	app-arch/unzip
	app-cdr/cdrtools
	app-crypt/swtpm
	app-emulation/spice
	app-misc/jq
	net-misc/curl
	net-misc/socat
	net-misc/spice-gtk[gtk3]
	net-misc/zsync
	sys-apps/coreutils
	sys-apps/gawk
	sys-apps/grep
	sys-apps/pciutils
	sys-apps/sed
	sys-apps/usbutils
	sys-apps/util-linux
	|| ( sys-firmware/edk2 sys-firmware/edk2-bin )
	sys-process/procps
	x11-apps/mesa-progs
	x11-apps/xrandr
	x11-misc/xdg-user-dirs
"
RDEPEND="${DEPEND}"

src_install() {
	python_doscript chunkcheck chunkcheck
	dobin quickemu
	dobin quickget
	dobin quickreport
	doman docs/quickemu.1
	doman docs/quickemu_conf.5
	doman docs/quickget.1
}
