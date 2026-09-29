# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit flag-o-matic linux-info meson python-single-r1 systemd

DESCRIPTION="Reliability, Availability and Serviceability logging tool"
HOMEPAGE="https://github.com/mchehab/rasdaemon"
SRC_URI="https://github.com/mchehab/rasdaemon/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="mysql postgres selinux +sqlite"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( mysql postgres sqlite )"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/libtraceevent
	$(python_gen_cond_dep 'dev-python/sphinx[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep 'dev-python/sqlalchemy[${PYTHON_USEDEP}]' -3)
	elibc_musl? ( sys-libs/argp-standalone )
	mysql? (
		dev-db/mysql-connector-c
		$(python_gen_cond_dep 'dev-python/mysqlclient[${PYTHON_USEDEP}]' -3)
	)
	postgres? (
		dev-db/postgresql:*
		$(python_gen_cond_dep 'dev-python/psycopg:2[${PYTHON_USEDEP}]' -3)
	)
	sqlite? ( dev-db/sqlite )
	sys-apps/pciutils
"
RDEPEND="
	${DEPEND}
	sys-apps/dmidecode
	selinux? ( sec-policy/selinux-rasdaemon )
"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/rasdaemon-1.0.0-systemd.patch
)

pkg_setup() {
	linux-info_pkg_setup
	local CONFIG_CHECK="~ACPI_EXTLOG ~DEBUG_FS"
	check_extra_config

	python-single-r1_pkg_setup
}

src_configure() {
	local arch="all"
	if use x86 || use amd64; then
		arch="x86"
	elif use arm || use arm64; then
		arch="arm"
	elif use riscv; then
		arch="riscv"
	fi

	local emesonargs=(
		-Denable-arch="${arch}"
		-Dabrt-report=enabled
		-Daer=enabled
		-Dampere-oem-sel=enabled
		-Dcpu-fault-isolation=enabled
		-Dcxl=enabled
		-Ddevlink=enabled
		-Ddiskerror=enabled
		-Derst=enabled
		-Dextlog=enabled
		-Dmemory-failure=enabled
		-Dmemory-ce-pfa=enabled
		-Dmemory-row-ce-pfa=enabled
		-Dmysql=$(usex mysql enabled disabled)
		-Dpostgresql=$(usex postgres enabled disabled)
		-Dsqlite3=$(usex sqlite enabled disabled)
	)

	use elibc_musl && append-libs -largp

	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
	rm "${ED}"/etc/ras/dimm_labels.d/meson.build || die

	keepdir "/var/lib/${PN}"

	systemd_dounit  "${BUILD_DIR}"/misc/*.service

	newinitd "${FILESDIR}/rasdaemon.openrc-r2" rasdaemon
	newinitd "${FILESDIR}/ras-mc-ctl.openrc-r1" ras-mc-ctl
	newconfd "${FILESDIR}"/rasdaemon.confd rasdaemon
}
