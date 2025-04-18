# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PVP="$(ver_cut 1-2)"

inherit gnome2 python-r1

# This ebuild does nothing -- we just want to get the pkgconfig file installed

MY_PN="gnome-python"
DESCRIPTION="Provides the base files for the gnome-python bindings"
HOMEPAGE="http://pygtk.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}-${PV}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha amd64 arm ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="${RESTRICT} mirror test"

# From the gnome-python eclass
RDEPEND=">=x11-libs/gtk+-2.6:2
	>=dev-libs/glib-2.6:2
	${PYTHON_DEPS}
	>=dev-python/pygtk-2.14.0:2[${PYTHON_USEDEP}]
	>=dev-python/pygobject-2.17:2[${PYTHON_USEDEP}]
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	python_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-allbindings
}
