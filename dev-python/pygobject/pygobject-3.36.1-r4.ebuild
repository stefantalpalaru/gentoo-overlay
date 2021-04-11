# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{8..10} )

inherit gnome.org meson python-r1 virtualx xdg

DESCRIPTION="Python bindings for GObject Introspection"
HOMEPAGE="https://pygobject.readthedocs.io/
		https://gitlab.gnome.org/GNOME/pygobject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cairo examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.48:2
	>=dev-libs/gobject-introspection-1.54:=
	dev-libs/libffi:=
	cairo? (
		$(python_gen_cond_dep '
			>=dev-python/pycairo-1.11.1:python2
		' -2)
		$(python_gen_cond_dep '
			>=dev-python/pycairo-1.11.1:0
		' -3)
		x11-libs/cairo[glib] )
"
DEPEND="${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	sed -i \
		-e "s/pycairo_name = 'pycairo'/pycairo_name = 'pycairo_py2'/" \
		meson.build || die
	default
}

src_configure() {
	configuring() {
		meson_src_configure \
			$(meson_use cairo pycairo) \
			$(meson_use test tests) \
			-Dpython="${EPYTHON}"
	}

	python_foreach_impl configuring
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_install() {
	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
	use examples && dodoc -r examples
}
