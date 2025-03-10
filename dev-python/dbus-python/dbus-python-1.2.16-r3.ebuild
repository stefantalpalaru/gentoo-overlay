# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit autotools python-r1

DESCRIPTION="Python bindings for the D-Bus messagebus"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/DBusBindings https://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="https://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~s390 sparc x86"

IUSE="doc examples test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	>=sys-apps/dbus-1.8:=
	>=dev-libs/glib-2.40
	!<dev-python/dbus-python-1.2.16-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( $(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]') )
	test? ( dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/tap-py[${PYTHON_USEDEP}] )
"

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	# Update py-compile, bug 529502.
	eautoreconf
	python_copy_sources
}

src_configure() {
	use doc && python_setup
	local SPHINX_IMPL=${EPYTHON}

	configuring() {
		local myconf=(
			--disable-documentation
		)
		[[ ${EPYTHON} == ${SPHINX_IMPL} ]] &&
			myconf+=( --enable-documentation )

		econf "${myconf[@]}"
	}
	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	find "${D}" -name '*.la' -type f -delete || die

	use examples && dodoc -r examples

	mv "${D}/usr/include/dbus-1.0/dbus/dbus-python.h" "${D}/usr/include/dbus-1.0/dbus/dbus-python2.h"
	mv "${D}/usr/$(get_libdir)/pkgconfig/dbus-python.pc" "${D}/usr/$(get_libdir)/pkgconfig/dbus-python2.pc"
}
