# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic linux-info linux-mod user versionator udev

PV_MAJOR=$(get_major_version)
PV_MINOR=$(get_version_component_range 2-3)

DESCRIPTION="VMware kernel modules"
HOMEPAGE="http://www.vmware.com/"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vmblock vmci vsock"
REQUIRED_USE="!vsock? ( !vmci )"

RDEPEND=""
DEPEND="
	=app-emulation/vmware-workstation-14.${PV_MINOR}*
"

S=${WORKDIR}

pkg_setup() {
	CONFIG_CHECK="~HIGH_RES_TIMERS"
	if kernel_is ge 2 6 37 && kernel_is lt 2 6 39; then
		CONFIG_CHECK="${CONFIG_CHECK} BKL"
	fi
	if use vmci ; then
		CONFIG_CHECK="${CONFIG_CHECK} !VMWARE_VMCI"
	else
		CONFIG_CHECK="${CONFIG_CHECK} VMWARE_VMCI"
	fi
	if use vsock ; then
		CONFIG_CHECK="${CONFIG_CHECK} !VMWARE_VMCI_VSOCKETS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} VMWARE_VMCI_VSOCKETS"
	fi

	linux-info_pkg_setup

	linux-mod_pkg_setup

	VMWARE_GROUP=${VMWARE_GROUP:-vmware}

	VMWARE_MODULE_LIST_ALL="vmblock vmmon vmnet vmci vsock"
	VMWARE_MODULE_LIST="vmmon vmnet"
	use vmci && VMWARE_MODULE_LIST="${VMWARE_MODULE_LIST} vmci"
	use vsock && VMWARE_MODULE_LIST="${VMWARE_MODULE_LIST} vsock"
	use vmblock && VMWARE_MODULE_LIST="${VMWARE_MODULE_LIST} vmblock"

	VMWARE_MOD_DIR="${PN}-${PVR}"

	BUILD_TARGETS="auto-build KERNEL_DIR=${KERNEL_DIR} KBUILD_OUTPUT=${KV_OUT_DIR}"

	enewgroup "${VMWARE_GROUP}"

	filter-flags -mfpmath=sse -mavx -mpclmul -maes
	append-cflags -mno-sse  # Found a problem similar to bug #492964

	for mod in ${VMWARE_MODULE_LIST}; do
		MODULE_NAMES="${MODULE_NAMES} ${mod}(misc:${S}/${mod}-only)"
	done
}

src_unpack() {
	cd "${S}"
	for mod in ${VMWARE_MODULE_LIST_ALL}; do
		tar -xf /opt/vmware/lib/vmware/modules/source/${mod}.tar
	done
}

src_prepare() {
	# from Arch Linux: https://aur.archlinux.org/packages/vmware-workstation/
	if use vmblock; then
		epatch "${FILESDIR}/${PV_MAJOR}-vmblock.patch"
	fi
	if use vmci; then
		epatch "${FILESDIR}/${PV_MAJOR}-vmci.patch"
	fi
	if use vsock; then
		epatch "${FILESDIR}/${PV_MAJOR}-vsock.patch"
		epatch "${FILESDIR}/${PV_MAJOR}-4.14-00-vsock-gcc-plugins-randstruct.patch"
	fi
	# from https://github.com/mkubecek/vmware-host-modules/tree/workstation-14.0.0
	epatch "${FILESDIR}/${PV_MAJOR}-00-vmmon-quick-workaround-for-objtool-warnings.patch"
	kernel_is ge 4 9 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.09-00-vmnet-use-standard-definition-of-PCI_VENDOR_ID_VMWAR.patch"
	kernel_is ge 4 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.10-00-vmnet-use-standard-definition-of-PCI_VENDOR_ID_VMWAR.patch"
	kernel_is ge 4 12 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.12-00-vmmon-use-standard-definition-of-MSR_MISC_FEATURES_E.patch"
	kernel_is ge 4 13 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.13-00-vmmon-use-standard-definition-of-CR3_PCID_MASK-if-av.patch"

	# decouple the kernel include dir from the running kernel version: https://github.com/stefantalpalaru/gentoo-overlay/issues/17
	sed -i -e "s%HEADER_DIR = /lib/modules/\$(VM_UNAME)/build/include%HEADER_DIR = ${KERNEL_DIR}/include%" */Makefile || die "sed failed"

	# Allow user patches so they can support RC kernels and whatever else
	default
}

src_install() {
	linux-mod_src_install
	local udevrules="${T}/60-vmware.rules"
	cat > "${udevrules}" <<-EOF
		KERNEL=="vmci",  GROUP="vmware", MODE="660"
		KERNEL=="vmw_vmci",  GROUP="vmware", MODE="660"
		KERNEL=="vmmon", GROUP="vmware", MODE="660"
		KERNEL=="vsock", GROUP="vmware", MODE="660"
	EOF
	udev_dorules "${udevrules}"

	if ! use vmci ; then
		dodir /etc/modprobe.d/

		cat > "${D}"/etc/modprobe.d/vmware.conf <<-EOF
			# Support for vmware vmci in kernel module
			alias vmci	vmw_vmci
		EOF

		export installed_modprobe_conf=1
	fi
	if ! use vsock ; then
		dodir /etc/modprobe.d/
		cat >> "${D}"/etc/modprobe.d/vmware.conf <<-EOF
			# Support for vmware vsock in kernel module
			alias vsock	vmw_vsock_vmci_transport
		EOF

		export installed_modprobe_conf=1
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if [ "${installed_modprobe_conf}"x == "x"  ] ; then
		if [ -f "${ROOT}/etc/modprobe.d/vmware.conf" ] ; then
			ewarn "Please check the /etc/modprobe.d/vmware.conf file and"
			ewarn "possible conflicts when using vmci and/or vsock modules built"
			ewarn "out of kernel"
		fi
	fi
}
