# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit git-r3 meson python-single-r1 udev

DESCRIPTION="Steering Wheel Manager for Linux"
HOMEPAGE="https://github.com/berarma/oversteer"
EGIT_REPO_URI="https://github.com/berarma/${PN}.git"
LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
PROPERTIES="test_network" # disable network-sandbox during testing

RDEPEND="
	${PYTHON_DEPS}

	$(python_gen_cond_dep '
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyudev[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
"

DEPEND="
	${RDEPEND}
"
src_configure() {
	local emesonargs=(
		-Dpython="${EPYTHON}"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize

	udev_dorules data/udev/99-fanatec-wheel-perms.rules
	udev_dorules data/udev/99-logitech-wheel-perms.rules
	udev_dorules data/udev/99-thrustmaster-wheel-perms.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
