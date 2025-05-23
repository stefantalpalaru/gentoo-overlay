# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 python-r1

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"
LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~s390 sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples libffi test"
RESTRICT="mirror !test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND=">=dev-libs/glib-2.24.0:2
	dev-lang/python-exec:2
	libffi? ( dev-libs/libffi:= )
	${PYTHON_DEPS}
"
DEPEND="${COMMON_DEPEND}
	dev-build/gtk-doc-am
	virtual/pkgconfig
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc )
"
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.23"

src_prepare() {
	# Fix FHS compliance, see upstream bug #535524
	patch -p1 -i "${FILESDIR}/${PN}-2.28.3-fix-codegen-location.patch"

	# Do not build tests if unneeded, bug #226345
	patch -p1 -i "${FILESDIR}/${PN}-2.28.3-make_check.patch"

	# Support installation for multiple Python versions, upstream bug #648292
	patch -p1 -i "${FILESDIR}/${PN}-2.28.3-support_multiple_python_versions.patch"

	# Disable tests that fail
	patch -p1 -i "${FILESDIR}/${P}-disable-failing-tests.patch"

	# Disable introspection tests when we build with --disable-introspection
	patch -p1 -i "${FILESDIR}/${P}-tests-no-introspection.patch"

	# Fix warning spam
	patch -p1 -i "${FILESDIR}/${P}-set_qdata.patch"
	patch -p1 -i "${FILESDIR}/${P}-gio-types-2.32.patch"

	# Fix glib-2.36 compatibility, bug #486602
	patch -p1 -i "${FILESDIR}/${P}-glib-2.36-class_init.patch"

	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.ac || die

	eautoreconf
	gnome2_src_prepare

	python_copy_sources

	_prepare_shebangs() {
		# Make a backup with unconverted shebangs to keep python_doscript happy
		cp codegen/codegen.py pygobject-codegen-2.0
		sed -e "s%#! \?/usr/bin/env python%#!${PYTHON}%" \
			-i codegen/*.py || die "shebang convertion failed"
	}
	python_foreach_impl run_in_build_dir _prepare_shebangs
}

src_configure() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	my_configure() {
		# --disable-introspection and --disable-cairo because we use pygobject:3
		# for introspection support
		gnome2_src_configure \
			--disable-introspection \
			--disable-cairo \
			$(use_with libffi ffi)
	}

	python_foreach_impl run_in_build_dir my_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

# FIXME: With python multiple ABI support, tests return 1 even when they pass
src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs

	testing() {
		export XDG_CACHE_HOME="${T}/${EPYTHON}"
		run_in_build_dir Xemake -j1 check
		unset XDG_CACHE_HOME
	}
	python_foreach_impl testing
	unset GIO_USE_VFS
}

src_install() {
	installing() {
		local f prefixed_sitedir

		gnome2_src_install

		python_doscript pygobject-codegen-2.0

		# Don't keep multiple copies of pygobject-codegen-2.0 script
		prefixed_sitedir=$(python_get_sitedir)
		dosym "${prefixed_sitedir#${EPREFIX}}/gtk-2.0/codegen/codegen.py" "/usr/lib/python-exec/${EPYTHON}/pygobject-codegen-2.0"
	}
	python_foreach_impl run_in_build_dir installing

	if use examples; then
		dodoc -r examples
	fi
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null || die
	"$@"
	popd > /dev/null
}
