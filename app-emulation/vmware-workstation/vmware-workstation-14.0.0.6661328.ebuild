# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator readme.gentoo-r1 gnome2-utils pam systemd xdg-utils

MY_PN="VMware-Workstation"
MY_PV=$(get_version_component_range 1-3)
PV_MODULES="329.$(get_version_component_range 2-3)"
PV_BUILD=$(get_version_component_range 4)
MY_P="${MY_PN}-${MY_PV}-${PV_BUILD}"

SYSTEMD_UNITS_TAG="gentoo-02"

DESCRIPTION="Emulate a complete PC without the performance overhead of most emulators"
HOMEPAGE="http://www.vmware.com/products/workstation/"
BASE_URI="https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${MY_PV}/${PV_BUILD}/linux/core/"
SRC_URI="
	${BASE_URI}${MY_P}.x86_64.bundle.tar
	macos-guests? ( https://github.com/DrDonk/unlocker/archive/fd216eb4892857ffc7755a965cedb8f740eb42ea.zip -> unlocker-2.1.1.zip )
	systemd? ( https://github.com/akhuettel/systemd-vmware/archive/${SYSTEMD_UNITS_TAG}.tar.gz -> vmware-systemd-${SYSTEMD_UNITS_TAG}.tgz )
	"

LICENSE="GPL-2 GPL-3 MIT-with-advertising vmware"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bundled-libs cups doc macos-guests ovftool server systemd vix vmware-tools"
RESTRICT="mirror strip"

BUNDLED_LIBS_DIR=/opt/vmware/lib/vmware/lib

BUNDLED_LIBS="
	libX11.so.6
	libXau.so.6
	libxcb.so.1
	libXcomposite.so.1
	libXcursor.so.1
	libXdamage.so.1
	libXdmcp.so.6
	libXext.so.6
	libXfixes.so.3
	libXft.so.2
	libXinerama.so.1
	libXi.so.6
	libXrandr.so.2
	libXrender.so.1
	libXtst.so.6
	libaio.so.1
	libatk-1.0.so.0
	libatk-bridge-2.0.so.0
	libatspi.so.0
	libcairo.so.2
	libcairo-gobject.so.2
	libcroco-0.6.so.3
	libcrypto.so.1.0.2
	libcurl.so.4
	libdbus-1.so.3
	libepoxy.so.0
	libexpat.so.1
	libffi.so.6
	libfontconfig.so.1
	libfreetype.so.6
	libfuse.so.2
	libgailutil-3.so.0
	libgcc_s.so.1
	libgck-1.so.0
	libgcr-base-3.so.1
	libgcr-ui-3.so.1
	libgcrypt.so.20
	libgdk-3.so.0
	libgdk_pixbuf-2.0.so.0
	libgio-2.0.so.0
	libglib-2.0.so.0
	libgmodule-2.0.so.0
	libgobject-2.0.so.0
	libgpg-error.so.0
	libgthread-2.0.so.0
	libgtk-3.so.0
	libharfbuzz.so.0
	libICE.so.6
	libjpeg.so.62
	libp11-kit.so.0
	libpango-1.0.so.0
	libpangocairo-1.0.so.0
	libpangoft2-1.0.so.0
	libpcre.so.1
	libpcsclite.so.1
	libpixman-1.so.0
	libpng12.so.0
	librsvg-2.so.2
	libsigc-2.0.so.0
	libSM.so.6
	libssl.so.1.0.2
	libstdc++.so.6
	libtasn1.so.6
	libtiff.so.5
	libxml2.so.2
	libz.so.1
"

BUNDLED_LIB_DEPENDS="
	app-accessibility/at-spi2-atk
	app-accessibility/at-spi2-core
	app-crypt/gcr[gtk]
	app-crypt/p11-kit
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libaio
	dev-libs/libcroco
	dev-libs/libffi
	dev-libs/libgcrypt:0/20
	dev-libs/libgpg-error
	dev-libs/libpcre
	dev-libs/libsigc++:2
	dev-libs/libtasn1:0/6
	dev-libs/libxml2
	dev-libs/openssl:0
	gnome-base/librsvg:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:0/0.9.18
	media-libs/libepoxy
	media-libs/libpng:1.2
	media-libs/tiff:0
	net-misc/curl
	sys-apps/dbus
	sys-apps/pcsc-lite
	sys-fs/fuse
	sys-libs/zlib
	virtual/jpeg:62
	x11-libs/cairo[glib]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/pixman
"

# vmware should not use virtual/libc as this is a
# precompiled binary package thats linked to glibc.
RDEPEND="
	app-arch/bzip2
	dev-libs/dbus-glib
	dev-libs/gmp:0
	dev-libs/icu
	dev-libs/json-c
	dev-libs/nettle:0/6.1
	gnome-base/gconf
	gnome-base/libgnome-keyring
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/libart_lgpl
	media-libs/libvorbis
	media-libs/mesa
	net-dns/libidn
	net-libs/gnutls
	cups? ( net-print/cups )
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	x11-libs/libXxf86vm
	x11-libs/libdrm
	x11-libs/libxshmfence
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-themes/hicolor-icon-theme
	!bundled-libs? ( ${BUNDLED_LIB_DEPENDS} )
	!app-emulation/vmware-player
"
PDEPEND="
	~app-emulation/vmware-modules-${PV_MODULES}
	vmware-tools? ( app-emulation/vmware-tools )"
DEPEND="
	dev-lang/python:2.7
	>=dev-util/patchelf-0.9
	ovftool? ( app-admin/chrpath )
"

S=${WORKDIR}/extracted
VM_INSTALL_DIR="/opt/vmware"
VM_DATA_STORE_DIR="/var/lib/vmware/Shared VMs"
VM_HOSTD_USER="root"

QA_PREBUILT="/opt/*"

QA_WX_LOAD="opt/vmware/lib/vmware/tools-upgraders/vmware-tools-upgrader-32 opt/vmware/lib/vmware/bin/vmware-vmx-stats opt/vmware/lib/vmware/bin/vmware-vmx-debug opt/vmware/lib/vmware/bin/vmware-vmx"

src_unpack() {
	default
	local bundle=${MY_P}.x86_64.bundle
	chmod 755 ${bundle}
	./${bundle} --console --extract extracted

	if ! use ovftool; then
		rm -r extracted/vmware-ovftool || die "unable to remove dir"
	fi

	if ! use server; then
		rm -r extracted/vmware-workstation-server || die "unable to remove dir"
	fi

	if ! use vix; then
		rm -r extracted/vmware-vix-core extracted/vmware-vix-lib-Workstation* || die "unable to remove dir"
	fi
}

clean_bundled_libs() {
	einfo "Removing bundled libraries"
	for libname in ${BUNDLED_LIBS} ; do
		rm -rf "${S}"/*/lib/lib/${libname}
	done

	rm -rf "${S}"/*/lib/libconf

	# Among the bundled libs there are libcrypto.so.1.0.2 and libssl.so.1.0.2
	# (needed by libcds.so) which seem to be compiled from openssl-1.0.1l.
	# Upstream real sonames are *so.1.0.0 so it's necessary to fix DT_NEEDED link
	# in libcds.so to be able to use system libs.
	pushd >/dev/null .
	einfo "Patching libcds.so"
	for d in "${S}"/*/lib/lib/libcds.so; do
		cd "${d}" || die
		patchelf --replace-needed libssl.so.1.0.{2,0} \
			--replace-needed libcrypto.so.1.0.{2,0} \
			libcds.so || die
		popd >/dev/null
	done
}

src_prepare() {
	default

	rm -f */bin/vmware-modconfig
	rm -rf */lib/modules/binary
	# Bug 459566
	mkdir vmware-network-editor/lib/lib
	mv vmware-network-editor/lib/libvmware-netcfg.so vmware-network-editor/lib/lib/

	if use server; then
		rm -f vmware-workstation-server/bin/{openssl,configure-hostd.sh}
	fi

	if ! use bundled-libs ; then
		clean_bundled_libs
	fi

	if use ovftool; then
		chrpath -d vmware-ovftool/libcurl.so.4
	fi

	if use macos-guests; then
		sed -i -e "s#vmx_path = '/usr#vmx_path = '${D}${VM_INSTALL_DIR//\//\\/}#" \
			-e "s#os\.path\.isfile('/usr#os.path.isfile('${D}${VM_INSTALL_DIR//\//\\/}#" \
			-e "s#vmwarebase = '/usr#vmwarebase = '${D}${VM_INSTALL_DIR//\//\\/}#" \
			"${WORKDIR}"/unlocker-*/unlocker.py
	fi

	DOC_CONTENTS="
/etc/env.d is updated during ${PN} installation. Please run:\n
'env-update && source /etc/profile'\n
Before you can use ${PN}, you must configure a default network setup.
You can do this by running 'emerge --config ${PN}'.\n
To be able to run ${PN} your user must be in the vmware group.\n
You MUST set USE=bundled-libs if you are running gcc-5, otherwise vmware will not start.
"
}

src_install() {
	local major_minor=$(get_version_component_range 1-2 "${PV}")
	local vmware_installer_version=$(cat "${S}/vmware-installer/manifest.xml" | grep -oPm1 "(?<=<version>)[^<]+")

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"${VM_INSTALL_DIR}\"" >> ${T}/10${PN}
	doins "${T}"/10${PN}

	# install the binaries
	into "${VM_INSTALL_DIR}"
	dobin */bin/*
	dosbin */sbin/*

	# install the libraries
	insinto "${VM_INSTALL_DIR}"/lib/vmware
	doins -r */lib/* vmware-vmx/roms
	rm -r "${D}${VM_INSTALL_DIR}"/lib/vmware/*.so

	# install the installer 
	insinto "${VM_INSTALL_DIR}"/lib/vmware-installer/$vmware_installer_version
	doins vmware-installer/{vmis,vmis-launcher,vmware-installer,vmware-installer.py}
	insinto /etc/vmware-installer
	doins vmware-installer/bootstrap

	# workaround for hardcoded search paths needed during shared objects loading
	if ! use bundled-libs ; then
		dosym /usr/$(get_libdir)/libglib-2.0.so.0 \
			"${VM_INSTALL_DIR}"/lib/vmware/lib/libglib-2.0.so.0/libglib-2.0.so.0
		# Bug 432918
		dosym /usr/$(get_libdir)/libcrypto.so.1.0.0 \
			"${VM_INSTALL_DIR}"/lib/vmware/lib/libcrypto.so.1.0.2/libcrypto.so.1.0.2
		dosym /usr/$(get_libdir)/libssl.so.1.0.0 \
			"${VM_INSTALL_DIR}"/lib/vmware/lib/libssl.so.1.0.2/libssl.so.1.0.2
	fi

	# install the ancillaries
	insinto /usr
	doins -r */share

	if use cups; then
		exeinto $(cups-config --serverbin)/filter
		doexe */extras/thnucups

		insinto /etc/cups
		doins -r */etc/cups/*
	fi

	if use doc; then
		dodoc -r */doc/*
	fi

	exeinto "${VM_INSTALL_DIR}"/lib/vmware/setup
	doexe */vmware-config

	# pam
	pamd_mimic_system vmware-authd auth account

	# install vmware workstation server
	if use server; then
		cd "${S}"/vmware-workstation-server

		# install binaries
		into "${VM_INSTALL_DIR}"/lib/vmware
		dobin "${FILESDIR}"/configure-hostd.sh

		# install the libraries
		insinto "${VM_INSTALL_DIR}"/lib/vmware/lib
		doins -r lib/*

		into "${VM_INSTALL_DIR}"
		for tool in vmware-hostd wssc-adminTool ; do
			cat > "${T}/${tool}" <<-EOF
				#!/usr/bin/env bash
				set -e

				. /etc/vmware/bootstrap

				exec "${VM_INSTALL_DIR}/lib/vmware/bin/${tool}" \\
					"\$@"
			EOF
			dobin "${T}/${tool}"
		done

		insinto "${VM_INSTALL_DIR}"/lib/vmware
		doins -r hostd

		# create the configuration
		insinto /etc/vmware
		doins -r config/etc/vmware/*
		doins -r etc/vmware/*

		# create directory for shared virtual machines.
		keepdir "${VM_DATA_STORE_DIR}"
		keepdir /var/log/vmware
	fi

	# install vmware-vix
	if use vix; then
		# install the binary
		into "${VM_INSTALL_DIR}"
		dobin "$S"/vmware-vix-*/bin/*

		# install the libraries
		insinto "${VM_INSTALL_DIR}"/lib/vmware-vix
		doins -r "$S"/vmware-vix-*/lib/*

		dosym vmware-vix/libvixAllProducts.so "${VM_INSTALL_DIR}"/lib/libbvixAllProducts.so

		# install headers
		insinto /usr/include/vmware-vix
		doins "$S"/vmware-vix-*/include/*

		if use doc; then
			dodoc -r "$S"/vmware-vix-*/doc/*
		fi
	fi

	# install ovftool
	if use ovftool; then
		cd "${S}"/vmware-ovftool

		insinto "${VM_INSTALL_DIR}"/lib/vmware-ovftool
		doins -r *

		chmod 0755 "${D}${VM_INSTALL_DIR}"/lib/vmware-ovftool/{ovftool,ovftool.bin}
		dosym "${D}${VM_INSTALL_DIR}"/lib/vmware-ovftool/ovftool "${VM_INSTALL_DIR}"/bin/ovftool
	fi

	# create symlinks for the various tools
	local tool ; for tool in thnuclnt vmware vmplayer{,-daemon} licenseTool vmamqpd \
			vmware-{app-control,enter-serial,gksu,fuseUI,hostd,modconfig{,-console},netcfg,tray,unity-helper,vim-cmd,vmblock-fuse,vprobe,wssc-adminTool,zenity} ; do
		dosym appLoader "${VM_INSTALL_DIR}"/lib/vmware/bin/"${tool}"
	done
	dosym "${VM_INSTALL_DIR}"/lib/vmware/bin/vmplayer "${VM_INSTALL_DIR}"/bin/vmplayer
	dosym "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware "${VM_INSTALL_DIR}"/bin/vmware
	dosym "${VM_INSTALL_DIR}"/lib/vmware/icu /etc/vmware/icu

	# fix permissions
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/bin/{appLoader,fusermount,mkisofs,vmware-remotemks}
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/setup/vmware-config
	fperms 4711 "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware-vmx{,-debug,-stats}
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/lib/libvmware-gksu.so/gksu-run-helper
	fperms 4711 "${VM_INSTALL_DIR}"/sbin/vmware-authd
	if use server; then
		fperms 0755 "${VM_INSTALL_DIR}"/bin/{vmware-hostd,wssc-adminTool}
		fperms 1777 "${VM_DATA_STORE_DIR}"
	fi
	if use vix; then
		fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware-vix/setup/vmware-config
	fi

	# create the environment
	local envd="${T}/90vmware"
	cat > "${envd}" <<-EOF
		PATH='${VM_INSTALL_DIR}/bin'
		ROOTPATH='${VM_INSTALL_DIR}/bin'
	EOF
	use bundled-libs && echo 'VMWARE_USE_SHIPPED_LIBS=1' >> "${envd}"

	doenvd "${envd}"

	# create the configuration
	dodir /etc/vmware

	cat > "${D}"/etc/vmware/bootstrap <<-EOF
		BINDIR='${VM_INSTALL_DIR}/bin'
		LIBDIR='${VM_INSTALL_DIR}/lib'
	EOF

	cat > "${D}"/etc/vmware/config <<-EOF
		bindir = "${VM_INSTALL_DIR}/bin"
		libdir = "${VM_INSTALL_DIR}/lib/vmware"
		initscriptdir = "/etc/init.d"
		authd.fullpath = "${VM_INSTALL_DIR}/sbin/vmware-authd"
		gksu.rootMethod = "su"
		VMCI_CONFED = "yes"
		VMBLOCK_CONFED = "yes"
		VSOCK_CONFED = "yes"
		NETWORKING = "yes"
		player.product.version = "${MY_PV}"
		product.buildNumber = "${PV_BUILD}"
		product.version = "${MY_PV}"
		product.name = "VMware Workstation"
		workstation.product.version = "${MY_PV}"
	EOF

	if use vix; then
		cat >> "${D}"/etc/vmware/config <<-EOF
			vmware.fullpath = "${VM_INSTALL_DIR}/bin/vmware"
			vix.libdir = "${VM_INSTALL_DIR}/lib/vmware-vix"
			vix.config.version = "1"
		EOF
	fi

	if use server; then
		cat >> "${D}"/etc/vmware/config <<-EOF
			authd.client.port = "902"
			authd.proxy.nfc = "vmware-hostd:ha-nfc"
			authd.soapserver = "TRUE"
		EOF
	fi

	# install the init.d script
	local initscript="${T}/vmware.rc"
	sed -e "s:@@BINDIR@@:${VM_INSTALL_DIR}/bin:g" \
		"${FILESDIR}/vmware-${major_minor}.rc" > "${initscript}" || die
	newinitd "${initscript}" vmware

	if use server; then
		# install the init.d script
		local initscript="${T}/vmware-workstation-server.rc"
		sed -e "s:@@ETCDIR@@:/etc/vmware:g" \
			-e "s:@@PREFIX@@:${VM_INSTALL_DIR}:g" \
			-e "s:@@BINDIR@@:${VM_INSTALL_DIR}/bin:g" \
			-e "s:@@LIBDIR@@:${VM_INSTALL_DIR}/lib/vmware:g" \
			"${FILESDIR}/vmware-server-${major_minor}.rc" > ${initscript} || die
		newinitd "${initscript}" vmware-workstation-server
	fi

	# fill in variable placeholders
	if use bundled-libs ; then
		sed -e "s:@@LIBCONF_DIR@@:${VM_INSTALL_DIR}/lib/vmware/libconf:g" \
			-i "${D}${VM_INSTALL_DIR}"/lib/vmware/libconf/etc/gtk-3.0/gdk-pixbuf.loaders || die
	fi
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmplayer:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-player.desktop" || die
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmware:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-workstation.desktop" || die
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmware-netcfg:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-netcfg.desktop" || die

	if use server; then
	# Configuration for vmware-workstation-server
		local hostdUser="${VM_HOSTD_USER:-root}"
		sed -e "/ACEDataUser/s:root:${hostdUser}:g" \
			-i "${D}/etc/vmware/hostd/authorization.xml" || die

		# Shared VMs Path: [standard].
		sed -e "s:##{DS_NAME}##:standard:g" \
			-e "s:##{DS_PATH}##:${VM_DATA_STORE_DIR}:g" \
			-i "${D}/etc/vmware/hostd/datastores.xml" || die

		sed -e "s:##{HTTP_PORT}##:-1:g" \
			-e "s:##{HTTPS_PORT}##:443:g" \
			-e "s:##{PIPE_PREFIX}##:/var/run/vmware/:g" \
			-i "${D}/etc/vmware/hostd/proxy.xml" || die

		# See vmware-workstation-server.py for more details.
		sed -e "s:##{BUILD_CFGDIR}##:/etc/vmware/hostd/:g" \
			-e "s:##{CFGALTDIR}##:/etc/vmware/hostd/:g" \
			-e "s:##{CFGDIR}##:/etc/vmware/:g" \
			-e "s:##{ENABLE_AUTH}##:true:g" \
			-e "s:##{HOSTDMODE}##:ws:g" \
			-e "s:##{HOSTD_CFGDIR}##:/etc/vmware/hostd/:g" \
			-e "s:##{HOSTD_MOCKUP}##:false:g" \
			-e "s:##{LIBDIR}##:${VM_INSTALL_DIR}/lib/vmware:g" \
			-e "s:##{LIBDIR_INSTALLED}##:${VM_INSTALL_DIR}/lib/vmware/:g" \
			-e "s:##{LOGDIR}##:/var/log/vmware/:g" \
			-e "s:##{LOGLEVEL}##:verbose:g" \
			-e "s:##{MOCKUP}##:mockup-host-config.xml:g" \
			-e "s:##{PLUGINDIR}##:./:g" \
			-e "s:##{SHLIB_PREFIX}##:lib:g" \
			-e "s:##{SHLIB_SUFFIX}##:.so:g" \
			-e "s:##{USE_BLKLISTSVC}##:false:g" \
			-e "s:##{USE_CBRCSVC}##:false:g" \
			-e "s:##{USE_CIMSVC}##:false:g" \
			-e "s:##{USE_DIRECTORYSVC}##:false:g" \
			-e "s:##{USE_DIRECTORYSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_DYNAMIC_PLUGIN_LOADING}##:false:g" \
			-e "s:##{USE_DYNAMO}##:false:g" \
			-e "s:##{USE_DYNSVC}##:false:g" \
			-e "s:##{USE_GUESTSVC}##:false:g" \
			-e "s:##{USE_HBRSVC}##:false:g" \
			-e "s:##{USE_HBRSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_HOSTSPECSVC}##:false:g" \
			-e "s:##{USE_HOSTSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_HTTPNFCSVC}##:false:g" \
			-e "s:##{USE_HTTPNFCSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_LICENSESVC_MOCKUP}##:false:g" \
			-e "s:##{USE_NFCSVC}##:true:g" \
			-e "s:##{USE_NFCSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_OVFMGRSVC}##:true:g" \
			-e "s:##{USE_PARTITIONSVC}##:false:g" \
			-e "s:##{USE_SECURESOAP}##:false:g" \
			-e "s:##{USE_SNMPSVC}##:false:g" \
			-e "s:##{USE_SOLO_MOCKUP}##:false:g" \
			-e "s:##{USE_STATSSVC}##:false:g" \
			-e "s:##{USE_STATSSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VCSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VSLMSVC}##:false:g" \
			-e "s:##{USE_VSLMSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VDISKSVC}##:false:g" \
			-e "s:##{USE_VDISKSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VMSVC_MOCKUP}##:false:g" \
			-e "s:##{VM_INVENTORY}##:vmInventory.xml:g" \
			-e "s:##{VM_RESOURCES}##:vmResources.xml:g" \
			-e "s:##{WEBSERVER_PORT_ENTRY}##::g" \
			-e "s:##{WORKINGDIR}##:./:g" \
			-i "${D}/etc/vmware/hostd/config.xml" || die

		sed -e "s:##{ENV_LOCATION}##:/etc/vmware/hostd/env/:g" \
			-i "${D}/etc/vmware/hostd/environments.xml" || die

		# @@VICLIENT_URL@@=XXX
		sed -e "s:@@AUTHD_PORT@@:902:g" \
			-i "${D}${VM_INSTALL_DIR}/lib/vmware/hostd/docroot/client/clients.xml" || die
	fi

	# install systemd unit files
	use systemd && systemd_dounit "${WORKDIR}/systemd-vmware-${SYSTEMD_UNITS_TAG}/"*.{service,target}

	# enable macOS guests support
	use macos-guests && python2 "${WORKDIR}"/unlocker-*/unlocker.py >/dev/null || die "unlocker.py failed"

	readme.gentoo_create_doc
}

pkg_config() {
	"${VM_INSTALL_DIR}"/bin/vmware-networks --postinstall ${PN},old,new
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}

pkg_prerm() {
	einfo "Stopping ${PN} for safe unmerge"
	/etc/init.d/vmware stop
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
