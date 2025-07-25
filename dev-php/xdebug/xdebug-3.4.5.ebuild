# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PHP_EXT_NAME="xdebug"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"
PHP_EXT_INIFILE="3.0-xdebug.ini"

USE_PHP="php8-2 php8-3 php8-4"

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

inherit php-ext-source-r3

DESCRIPTION="A PHP debugging and profiling extension"
HOMEPAGE="https://xdebug.org/"
# Using tarball from GitHub for tests
#SRC_URI="https://pecl.php.net/get/${PN}-${MY_PV}.tgz"
SRC_URI="https://github.com/xdebug/xdebug/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="Xdebug"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc64 x86"
# Tests are known to fail
RESTRICT="test"

RDEPEND="${DEPEND}"
DOCS=( README.rst CREDITS )
PHP_EXT_ECONF_ARGS=()

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		TEST_PHP_EXECUTABLE="${PHPCLI}" \
		TEST_PHP_CGI_EXECUTABLE="${PHPCGI}" \
		TEST_PHPDBG_EXECUTABLE="${PHPCLI}dbg" \
		 "${PHPCLI}" run-xdebug-tests.php
	done
}

pkg_postinst() {
	ewarn "We have set xdebug.mode to off, as xdebug can be"
	ewarn "installed as a dependency, and not all users will want xdebug to be"
	ewarn "enabled by default. If you want to enable it, you should edit the"
	ewarn "ini file and set xdebug.mode to one or more modes e.g. develop,debug,trace"
	elog ""
	elog "The 3.0 major release changes many options."
	elog "Review https://xdebug.org/docs/upgrade_guide for differences from 2.x"
}
