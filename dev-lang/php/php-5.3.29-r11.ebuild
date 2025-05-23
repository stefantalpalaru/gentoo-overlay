# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools depend.apache flag-o-matic multilib systemd

PHP_MV="$(ver_cut 1)"

# alias, so we can handle different types of releases (finals, rcs, alphas,
# betas, ...) w/o changing the whole ebuild
PHP_PV="${PV/_rc/RC}"
PHP_PV="${PHP_PV/_alpha/alpha}"
PHP_PV="${PHP_PV/_beta/beta}"
PHP_RELEASE="php"
[[ ${PV} == ${PV/_alpha/} ]] || PHP_RELEASE="php-pre"
[[ ${PV} == ${PV/_beta/} ]] || PHP_RELEASE="php-pre"
[[ ${PV} == ${PV/_rc/} ]] || PHP_RELEASE="php-pre"
PHP_P="${PN}-${PHP_PV}"

php_get_uri () {
	case "${1}" in
		"php-pre")
			echo "http://downloads.php.net/johannes/${2}"
		;;
		"php")
			echo "http://www.php.net/distributions/${2}"
		;;
		"gentoo")
			echo "mirror://gentoo/${2}"
		;;
		*)
			die "unhandled case in php_get_uri"
		;;
	esac
}

PHP_SRC_URI="$(php_get_uri "${PHP_RELEASE}" "${PHP_P}.tar.bz2")"

PHP_FPM_INIT_VER="4"
PHP_FPM_CONF_VER="1"

DESCRIPTION="The PHP language runtime engine: CLI, CGI, FPM/FastCGI, Apache2 and embed SAPIs"
HOMEPAGE="http://php.net/"
SRC_URI="${PHP_SRC_URI}"
S="${WORKDIR}/${PHP_P}"
LICENSE="PHP-3"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

# We can build the following SAPIs in the given order
SAPIS="embed cli cgi fpm apache2"

# SAPIs and SAPI-specific USE flags (cli SAPI is default on):
IUSE="${IUSE}
	${SAPIS/cli/+cli}
	threads"

IUSE="${IUSE} bcmath berkdb bzip2 calendar cdb cjk
	crypt +ctype curl curlwrappers debug
	enchant exif +fileinfo +filter
	flatfile ftp gd gdbm gmp +hash +iconv inifile
	intl iodbc ipv6 +json kerberos ldap ldap-sasl libedit mhash
	mssql mysql mysqli nls
	odbc pcntl pdo +phar +posix postgres qdbm
	readline recode selinux +session sharedmem
	+simplexml snmp soap sockets spell sqlite ssl
	sybase-ct sysvipc tidy +tokenizer truetype unicode wddx
	+xml xmlreader xmlwriter xmlrpc xpm xslt zip zlib"

DEPEND="
	>=app-eselect/eselect-php-0.7.1-r3[apache2?,fpm?]
	>=dev-libs/libpcre-8.32[unicode]
	apache2? ( www-servers/apache[threads=] )
	berkdb? ( =sys-libs/db-4*:* )
	bzip2? ( app-arch/bzip2 )
	cdb? ( || ( dev-db/cdb dev-db/tinycdb ) )
	cjk? ( !gd? (
		media-libs/libjpeg-turbo:0
		media-libs/libpng:0=
		sys-libs/zlib
	) )
	crypt? ( >=dev-libs/libmcrypt-2.4 )
	curl? ( >=net-misc/curl-7.10.5 )
	enchant? ( app-text/enchant:0 )
	exif? ( !gd? (
		media-libs/libjpeg-turbo:0
		media-libs/libpng:0=
		sys-libs/zlib
	) )
	gd? ( media-libs/libjpeg-turbo:0 media-libs/libpng:0= sys-libs/zlib )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	gmp? ( >=dev-libs/gmp-4.1.2:* )
	iconv? ( virtual/libiconv )
	intl? ( dev-libs/icu:0/64.2 )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-1.2.11 )
	ldap-sasl? ( dev-libs/cyrus-sasl >=net-nds/openldap-1.2.11 )
	libedit? ( dev-libs/libedit )
	mssql? ( dev-db/freetds[mssql] )
	nls? ( sys-devel/gettext )
	odbc? ( >=dev-db/unixODBC-1.8.13 )
	postgres? ( dev-db/postgresql:* )
	qdbm? ( dev-db/qdbm )
	readline? ( sys-libs/readline:* )
	recode? ( app-text/recode )
	sharedmem? ( dev-libs/mm )
	simplexml? ( >=dev-libs/libxml2-2.6.8 )
	snmp? ( >=net-analyzer/net-snmp-5.2 )
	soap? ( >=dev-libs/libxml2-2.6.8 )
	spell? ( >=app-text/aspell-0.50 )
	sqlite? ( >=dev-db/sqlite-3.7.7.1 )
	ssl? ( >=dev-libs/openssl-1.0.2:0 )
	sybase-ct? ( dev-db/freetds )
	tidy? ( app-text/htmltidy )
	truetype? (
		=media-libs/freetype-2*
		>=media-libs/t1lib-5.0.0
		!gd? (
			media-libs/libjpeg-turbo:0 media-libs/libpng:0= sys-libs/zlib )
	)
	unicode? ( dev-libs/oniguruma )
	wddx? ( >=dev-libs/libxml2-2.6.8 )
	xml? ( >=dev-libs/libxml2-2.6.8 )
	xmlrpc? ( >=dev-libs/libxml2-2.6.8 virtual/libiconv )
	xmlreader? ( >=dev-libs/libxml2-2.6.8 )
	xmlwriter? ( >=dev-libs/libxml2-2.6.8 )
	xpm? (
		x11-libs/libXpm
		media-libs/libjpeg-turbo:0
		media-libs/libpng:0= sys-libs/zlib
	)
	xslt? ( dev-libs/libxslt >=dev-libs/libxml2-2.6.8 )
	zip? ( sys-libs/zlib )
	zlib? ( sys-libs/zlib )
	virtual/mta
"

php="=${CATEGORY}/${PF}"

REQUIRED_USE="
	truetype? ( gd )
	cjk? ( gd )
	exif? ( gd )

	xpm? ( gd )
	gd? ( zlib )
	simplexml? ( xml )
	soap? ( xml )
	wddx? ( xml )
	xmlrpc? ( || ( xml iconv ) )
	xmlreader? ( xml )
	xslt? ( xml )
	ldap-sasl? ( ldap )
	mhash? ( hash )
	phar? ( hash )

	qdbm? ( !gdbm )
	readline? ( !libedit )
	recode? ( !mysql !mysqli )
	sharedmem? ( !threads )

	!cli? ( !cgi? ( !fpm? ( !apache2? ( !embed? ( cli ) ) ) ) )"

RESTRICT="mirror"

RDEPEND="${DEPEND}
	fpm? ( selinux? ( sec-policy/selinux-phpfpm ) )"

BDEPEND="${DEPEND}
	~app-alternatives/yacc-0
	<sys-devel/bison-3
	sys-devel/flex
	>=sys-devel/m4-1.4.3
	>=dev-build/libtool-1.5.18"

# Allow users to install production version if they want to

case "${PHP_INI_VERSION}" in
	production|development)
		;;
	*)
		PHP_INI_VERSION="development"
		;;
esac

PHP_INI_UPSTREAM="php.ini-${PHP_INI_VERSION}"
PHP_INI_FILE="php.ini"

want_apache

pkg_setup() {
	depend.apache_pkg_setup
}

php_install_ini() {
	local phpsapi="${1}"

	# work out where we are installing the ini file
	php_set_ini_dir "${phpsapi}"

	local phpinisrc="${PHP_INI_UPSTREAM}-${phpsapi}"
	cp "${PHP_INI_UPSTREAM}" "${phpinisrc}"

	# default to /tmp for save_path, bug #282768
	sed -e 's|^;session.save_path .*$|session.save_path = "'"${EPREFIX}"'/tmp"|g' -i "${phpinisrc}"

	# Set the extension dir
	sed -e "s|^extension_dir .*$|extension_dir = ${extension_dir}|g" -i "${phpinisrc}"

	# Set the include path to point to where we want to find PEAR packages
	sed -e 's|^;include_path = ".:/php/includes".*|include_path = ".:'"${EPREFIX}"'/usr/share/php'${PHP_MV}':'"${EPREFIX}"'/usr/share/php"|' -i "${phpinisrc}"

	if in_iuse opcache && use opcache; then
		elog "Adding opcache to ${phpinisrc}"
		echo "zend_extension=${PHP_DESTDIR}/$(get_libdir)/opcache.so" >> ${phpinisrc}
	fi

	insinto "${PHP_INI_DIR#${EPREFIX}}"
	newins "${phpinisrc}" "${PHP_INI_FILE}"

	elog "Installing php.ini for ${phpsapi} into ${PHP_INI_DIR#${EPREFIX}}"
	elog

	dodir "${PHP_EXT_INI_DIR#${EPREFIX}}"
	dodir "${PHP_EXT_INI_DIR_ACTIVE#${EPREFIX}}"

	# SAPI-specific handling

	if [[ "${sapi}" == "fpm" ]] ; then
		[[ -z ${PHP_FPM_CONF_VER} ]] && PHP_FPM_CONF_VER=0
		einfo "Installing FPM CGI config file php-fpm.conf"
		insinto "${PHP_INI_DIR#${EPREFIX}}"
		newins "${FILESDIR}/php-fpm-r${PHP_FPM_CONF_VER}.conf" php-fpm.conf

		# Remove bogus /etc/php-fpm.conf.default (bug 359906)
		[[ -f "${ED}/etc/php-fpm.conf.default" ]] && rm "${ED}/etc/php-fpm.conf.default"
	fi

	# Install PHP ini files into /usr/share/php

	dodoc php.ini-development
	dodoc php.ini-production

}

php_set_ini_dir() {
	PHP_INI_DIR="${EPREFIX}/etc/php/${1}-php${SLOT}"
	PHP_EXT_INI_DIR="${PHP_INI_DIR}/ext"
	PHP_EXT_INI_DIR_ACTIVE="${PHP_INI_DIR}/ext-active"
}

src_prepare() {
	default

	append-cflags -fpermissive -std=gnu17 -fno-strict-aliasing

	patch -p1 -i "${FILESDIR}/php-5.5.14-remove-randegd.diff" || die
	# USE=sharedmem (session/mod_mm to be exact) tries to mmap() this path
	# ([empty session.save_path]/session_mm_[sapi][gid].sem)
	# there is no easy way to circumvent that, all php calls during
	# install use -n, so no php.ini file will be used.
	# As such, this is the easiest way to get around
	addpredict /session_mm_cli250.sem
	addpredict /session_mm_cli0.sem

	# Change PHP branding
	sed -re	"s|^(PHP_EXTRA_VERSION=\").*(\")|\1-pl${PR/r/}-gentoo\2|g" \
		-i configure.in || die "Unable to change PHP branding"

	# Apply generic PHP patches
	for P in "${FILESDIR}/patches/generic"/*.patch; do
		patch -p1 -i "${P}" || die
	done

	#Fix bug 463498
	patch -p1 -i "${FILESDIR}/fix-libstdc++-underlinking.patch" || die

	# Patch for pkg-config-0.28 (Bug 455040)
	patch -p1 -i "${FILESDIR}"/missing-openssl-include.patch || die

	patch -p1 -i "${FILESDIR}"/bison_build_2a.patch || die
	patch -p1 -i "${FILESDIR}"/bison_any_version.patch || die
	rm Zend/zend_{language,ini}_parser.[ch]

	patch -p1 -i "${FILESDIR}"/freetype.patch || die

	# Patch PHP to show Gentoo as the server platform
	sed -e 's/PHP_UNAME=`uname -a | xargs`/PHP_UNAME=`uname -s -n -r -v | xargs`/g' \
		-i configure.in || die "Failed to fix server platform name"

	# Prevent PHP from activating the Apache config,
	# as we will do that ourselves
	sed -i \
		-e "s,-i -a -n php${PHP_MV},-i -n php${PHP_MV},g" \
		-e "s,-i -A -n php${PHP_MV},-i -n php${PHP_MV},g" \
		sapi/apache2filter/config.m4 sapi/apache2handler/config.m4

	# Patch PHP to support heimdal instead of mit-krb5
	if has_version "app-crypt/heimdal" ; then
		sed -e 's|gssapi_krb5|gssapi|g' -i acinclude.m4 \
			|| die "Failed to fix heimdal libname"
		sed -e 's|PHP_ADD_LIBRARY(k5crypto, 1, $1)||g' -i acinclude.m4 \
			|| die "Failed to fix heimdal crypt library reference"
	fi

	# modern mysql and mariadb libraries are already reentrant
	patch -p1 -i "${FILESDIR}"/libmysqlclient.patch || die
	# mariadb puts my_global.h in /usr/include/mysql/server
	patch -p1 -i "${FILESDIR}"/mysql-include.patch || die

	# support >=oniguruma-6.8.1
	patch -p1 -i "${FILESDIR}"/oniguruma.patch || die

	# support OpenSSL-1.1
	patch -p1 -i "${FILESDIR}"/openssl-1.1.patch || die

	#force rebuilding aclocal.m4
	rm aclocal.m4

	# work around divert() issues with newer autoconf, bug #281697
	if has_version '>=sys-devel/autoconf-2.64' ; then
		sed -i -r \
			-e 's:^((m4_)?divert)[(]([0-9]*)[)]:\1(600\3):' \
			$(grep -l divert $(find . -name '*.m4') configure.in) || die
	fi
	mv configure.in configure.ac
	eautoreconf --force -W no-cross
}

src_configure() {
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	PHP_DESTDIR="/usr/$(get_libdir)/php${SLOT}"

	# This is a global variable and should be in caps. It isn't because the
	# phpconfutils eclass relies on exactly this name...
	# for --with-libdir see bug #327025
	my_conf="--prefix=${PHP_DESTDIR}
		--mandir=${PHP_DESTDIR}/man
		--infodir=${PHP_DESTDIR}/info
		--libdir=${PHP_DESTDIR}/lib
		--with-libdir=$(get_libdir)
		--without-pear
		$(use_enable threads maintainer-zts)"

	#                             extension		  USE flag        shared
	my_conf+="
	$(use_enable bcmath bcmath )
	$(use_with bzip2 bz2 )
	$(use_enable calendar calendar )
	$(use_enable ctype ctype )
	$(use_with curl curl )
	$(use_with curlwrappers curlwrappers )
	$(use_enable xml dom )
	$(use_with enchant enchant /usr)
	$(use_enable exif exif )
	$(use_enable fileinfo fileinfo )
	$(use_enable filter filter )
	$(use_enable ftp ftp )
	$(use_with nls gettext )
	$(use_with gmp gmp )
	$(use_enable hash hash )
	$(use_with mhash mhash )
	$(use_with iconv iconv )
	$(use_enable intl intl )
	$(use_enable ipv6 ipv6 )
	$(use_enable json json )
	$(use_with kerberos kerberos /usr)
	$(use_enable xml libxml )
	$(use_enable unicode mbstring )
	$(use_with crypt mcrypt )
	$(use_with mssql mssql )
	$(use_with unicode onig /usr)
	$(use_with ssl openssl )
	$(use_with ssl openssl-dir /usr)
	$(use_enable pcntl pcntl )
	$(use_enable phar phar )
	$(use_enable pdo pdo )
	$(use_with postgres pgsql )
	$(use_enable posix posix )
	$(use_with spell pspell )
	$(use_with recode recode )
	$(use_enable simplexml simplexml )
	$(use_enable sharedmem shmop )
	$(use_with snmp snmp )
	$(use_enable soap soap )
	$(use_enable sockets sockets )
	$(use_with sqlite sqlite3 /usr)
	$(use_with sybase-ct sybase-ct /usr)
	$(use_enable sysvipc sysvmsg )
	$(use_enable sysvipc sysvsem )
	$(use_enable sysvipc sysvshm )
	$(use_with tidy tidy )
	$(use_enable tokenizer tokenizer )
	$(use_enable wddx wddx )
	$(use_enable xml xml )
	$(use_enable xmlreader xmlreader )
	$(use_enable xmlwriter xmlwriter )
	$(use_with xmlrpc xmlrpc )
	$(use_with xslt xsl )
	$(use_enable zip zip )
	$(use_with zlib zlib )
	$(use_enable debug debug )"

	# DBA support
	if use cdb || use berkdb || use flatfile || use gdbm || use inifile \
		|| use qdbm ; then
		my_conf="${my_conf} --enable-dba${shared}"
	fi

	# DBA drivers support
	my_conf+="
	$(use_with cdb cdb )
	$(use_with berkdb db4 )
	$(use_enable flatfile flatfile )
	$(use_with gdbm gdbm )
	$(use_enable inifile inifile )
	$(use_with qdbm qdbm )"

	# Support for the GD graphics library
	my_conf+="
	$(use_with truetype freetype-dir /usr)
	$(use_with truetype t1lib /usr)
	$(use_enable cjk gd-jis-conv )
	$(use_with gd jpeg-dir /usr)
	$(use_with gd png-dir /usr)
	$(use_with xpm xpm-dir /usr)"
	# enable gd last, so configure can pick up the previous settings
	my_conf+="
	$(use_with gd gd )"

	# LDAP support
	if use ldap ; then
		my_conf+="
		$(use_with ldap ldap )
		$(use_with ldap-sasl ldap-sasl )"
	fi

	# MySQL support
	if use mysql ; then
		my_conf+="
		$(use_with mysql mysql mysqlnd)
		$(use_with mysql mysql-sock /var/run/mysqld/mysqld.sock)"
	fi

	# MySQLi support
	my_conf+="
	$(use_with mysqli mysqli mysqlnd)"

	# ODBC support
	if use odbc ; then
		my_conf+="
		$(use_with odbc unixODBC /usr)"
	fi

	if use iodbc ; then
		my_conf+="
		$(use_with iodbc iodbc /usr)"
	fi

	# PDO support
	if use pdo ; then
		my_conf+="
		$(use_with mssql pdo-dblib )
		$(use_with mysql pdo-mysql mysqlnd)
		$(use_with postgres pdo-pgsql )
		$(use_with sqlite pdo-sqlite /usr)
		$(use_with odbc pdo-odbc unixODBC,/usr)"
	fi

	# readline/libedit support
	my_conf+="
	$(use_with readline readline )
	$(use_with libedit libedit )"

	# Session support
	if use session ; then
		my_conf+="
		$(use_with sharedmem mm )"
	else
		my_conf+="
		$(use_enable session session )"
	fi

	# Use pic for shared modules such as apache2's mod_php
	my_conf="${my_conf} --with-pic"

	# we use the system copy of pcre
	# --with-pcre-regex affects ext/pcre
	# --with-pcre-dir affects ext/filter and ext/zip
	my_conf="${my_conf} --with-pcre-regex=/usr --with-pcre-dir=/usr"

	# Catch CFLAGS problems
	# Fixes bug #14067.
	# Changed order to run it in reverse for bug #32022 and #12021.
	replace-cpu-flags "k6*" "i586"

	append-flags "-DTRUE=1 -DFALSE=0"

	# Support user-passed configuration parameters
	my_conf="${my_conf} ${EXTRA_ECONF:-}"

	# Support the Apache2 extras, they must be set globally for all
	# SAPIs to work correctly, especially for external PHP extensions

	mkdir -p "${WORKDIR}/sapis-build"
	for one_sapi in $SAPIS ; do
		use "${one_sapi}" || continue
		php_set_ini_dir "${one_sapi}"

		cp -r "${S}" "${WORKDIR}/sapis-build/${one_sapi}"
		cd "${WORKDIR}/sapis-build/${one_sapi}"

		sapi_conf="${my_conf} --with-config-file-path=${PHP_INI_DIR}
			--with-config-file-scan-dir=${PHP_EXT_INI_DIR_ACTIVE}"

		for sapi in $SAPIS ; do
			case "$sapi" in
				cli|cgi|embed|fpm)
					if [[ "${one_sapi}" == "${sapi}" ]] ; then
						sapi_conf="${sapi_conf} --enable-${sapi}"
					else
						sapi_conf="${sapi_conf} --disable-${sapi}"
					fi
					;;

				apache2)
					if [[ "${one_sapi}" == "${sapi}" ]] ; then
						sapi_conf="${sapi_conf} --with-apxs2=/usr/sbin/apxs"
					else
						sapi_conf="${sapi_conf} --without-apxs2"
					fi
					;;
			esac
		done

		econf ${sapi_conf}
	done
}

src_compile() {
	# snmp seems to run during src_compile, too (bug #324739)
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	for sapi in ${SAPIS} ; do
		if use "${sapi}"; then
			cd "${WORKDIR}/sapis-build/$sapi" || "Failed to change dir to ${WORKDIR}/sapis-build/$1"
			emake || die "emake failed"
		fi
	done
}

src_install() {
	# see bug #324739 for what happens when we don't have that
	addpredict /usr/share/snmp/mibs/.index

	# grab the first SAPI that got built and install common files from there
	local first_sapi=""
	for sapi in $SAPIS ; do
		if use $sapi ; then
			first_sapi=$sapi
			break
		fi
	done

	# Makefile forgets to create this before trying to write to it...
	dodir "${PHP_DESTDIR#${EPREFIX}}/bin"

	# Install php environment (without any sapis)
	cd "${WORKDIR}/sapis-build/$first_sapi"
	emake INSTALL_ROOT="${D}" \
		install-build install-headers install-programs \
		|| die "emake install failed"

	local extension_dir="$("${ED}/${PHP_DESTDIR#${EPREFIX}}/bin/php-config" --extension-dir)"

	# Create the directory where we'll put version-specific php scripts
	keepdir /usr/share/php${PHP_MV}

	local sapi="", file=""
	local sapi_list=""

	for sapi in ${SAPIS}; do
		if use "${sapi}" ; then
			einfo "Installing SAPI: ${sapi}"
			cd "${WORKDIR}/sapis-build/${sapi}"

			if [[ "${sapi}" == "apache2" ]] ; then
				# We're specifically not using emake install-sapi as libtool
				# may cause unnecessary relink failures (see bug #351266)
				insinto "${PHP_DESTDIR#${EPREFIX}}/apache2/"
				newins ".libs/libphp5$(get_libname)" "libphp${PHP_MV}$(get_libname)"
				keepdir "/usr/$(get_libdir)/apache2/modules"
			else
				# needed each time, php_install_ini would reset it
				local dest="${PHP_DESTDIR#${EPREFIX}}"
				into "${dest}"
				case "$sapi" in
					cli)
						source="sapi/cli/php"
						;;
					cgi)
						source="sapi/cgi/php-cgi"
						;;
					fpm)
						source="sapi/fpm/php-fpm"
						;;
					embed)
						source="libs/libphp${PHP_MV}$(get_libname)"
						;;
					*)
						die "unhandled sapi in src_install"
						;;
				esac

				if [[ "${source}" == *"$(get_libname)" ]]; then
					dolib.so "${source}" || die "Unable to install ${sapi} sapi"
				else
					dobin "${source}" || die "Unable to install ${sapi} sapi"
					local name="$(basename ${source})"
					dosym "${dest}/bin/${name}" "/usr/bin/${name}${SLOT}"
				fi
			fi

			php_install_ini "${sapi}"

			# construct correct SAPI string for php-config
			# thanks to ferringb for the bash voodoo
			if [[ "${sapi}" == "apache2" ]]; then
				sapi_list="${sapi_list:+${sapi_list} }apache2handler"
			else
				sapi_list="${sapi_list:+${sapi_list} }${sapi}"
			fi
		fi
	done

	# Installing opcache module
	if in_iuse opcache && use opcache; then
		dolib.so "modules/opcache$(get_libname)" || die "Unable to install opcache module"
	fi

	# Install env.d files
	newenvd "${FILESDIR}/20php5-envd" \
		"20php${SLOT}"
	sed -e "s|/lib/|/$(get_libdir)/|g" -i \
		"${ED}/etc/env.d/20php${SLOT}"
	sed -e "s|php5|php${SLOT}|g" -i \
		"${ED}/etc/env.d/20php${SLOT}"

	# set php-config variable correctly (bug #278439)
	sed -e "s:^\(php_sapis=\)\".*\"$:\1\"${sapi_list}\":" -i \
		"${ED}/usr/$(get_libdir)/php${SLOT}/bin/php-config"

	use fpm && systemd_newunit "${FILESDIR}/php-fpm_at-simple.service" "php-fpm@${SLOT}.service"

	find "${ED}" -name '*.la' -delete || die
}

src_test() {
	echo ">>> Test phase [test]: ${CATEGORY}/${PF}"
	PHP_BIN="${WORKDIR}/sapis-build/cli/sapi/cli/php"
	if [[ ! -x "${PHP_BIN}" ]] ; then
		ewarn "Test phase requires USE=cli, skipping"
		return
	else
		export TEST_PHP_EXECUTABLE="${PHP_BIN}"
	fi

	if [[ -x "${WORKDIR}/sapis/cgi/php-cgi" ]] ; then
		export TEST_PHP_CGI_EXECUTABLE="${WORKDIR}/sapis/cgi/php-cgi"
	fi

	REPORT_EXIT_STATUS=1 "${TEST_PHP_EXECUTABLE}" -n  -d "session.save_path=${T}" \
		"${WORKDIR}/sapis-build/cli/run-tests.php" -n -q -d "session.save_path=${T}"

	for name in ${EXPECTED_TEST_FAILURES}; do
		mv "${name}.out" "${name}.out.orig" 2>/dev/null
	done

	local failed="$(find -name '*.out')"
	if [[ ${failed} != "" ]] ; then
		ewarn "The following test cases failed unexpectedly:"
		for name in ${failed}; do
			ewarn "  ${name/.out/}"
		done
	else
		einfo "No unexpected test failures, all fine"
	fi

	if [[ ${PHP_SHOW_UNEXPECTED_TEST_PASS} == "1" ]] ; then
		local passed=""
		for name in ${EXPECTED_TEST_FAILURES}; do
			[[ -f "${name}.diff" ]] && continue
			passed="${passed} ${name}"
		done
		if [[ ${passed} != "" ]] ; then
			einfo "The following test cases passed unexpectedly:"
			for name in ${passed}; do
				ewarn "  ${passed}"
			done
		else
			einfo "None of the known-to-fail tests passed, all fine"
		fi
	fi
}

# @FUNCTION: apache-module_pkg_postinst
# @DESCRIPTION:
# This prints out information about the installed module and how to enable it.
apache_module_pkg_postinst() {
	debug-print-function $FUNCNAME $*

	if [[ -n "${APACHE2_MOD_DEFINE}" ]] ; then
		local my_opts="-D ${APACHE2_MOD_DEFINE// / -D }"

		einfo
		einfo "To enable ${PN}, you need to edit your /etc/conf.d/apache2 file and"
		einfo "add '${my_opts}' to APACHE2_OPTS."
		einfo
	fi

	if [[ -n "${APACHE2_MOD_CONF}" ]] ; then
		set -- ${APACHE2_MOD_CONF}
		einfo
		einfo "Configuration file installed as"
		einfo "    ${APACHE_MODULES_CONFDIR}/$(basename ${2:-$1}).conf"
		einfo "You may want to edit it before turning the module on in /etc/conf.d/apache2"
		einfo
	fi
}

pkg_postinst() {
	# Output some general info to the user
	if use apache2 ; then
		APACHE2_MOD_DEFINE="PHP5"
		APACHE2_MOD_CONF="70_mod_php5"
		apache_module_pkg_postinst
	fi

	# Create the symlinks for php
	for m in ${SAPIS}; do
		[[ ${m} == 'embed' ]] && continue;
		if use $m ; then
			local ci=$(eselect php show $m)
			if [[ -z $ci ]]; then
				eselect php set $m php${SLOT}
				einfo "Switched ${m} to use php:${SLOT}"
				einfo
			elif [[ $ci != "php${SLOT}" ]] ; then
				elog "To switch $m to use php:${SLOT}, run"
				elog "    eselect php set $m php${SLOT}"
				elog
			fi
		fi
	done

	elog "Make sure that PHP_TARGETS in /etc/make.conf includes php${SLOT/./-} in order"
	elog "to compile extensions for the ${SLOT} ABI"
	elog
	if ! use readline && use cli ; then
		ewarn "Note that in order to use php interactivly, you need to enable"
		ewarn "the readline USE flag or php -a will hang"
	fi
	elog
	elog "This ebuild installed a version of php.ini based on php.ini-${PHP_INI_VERSION} version."
	elog "You can chose which version of php.ini to install by default by setting PHP_INI_VERSION to either"
	elog "'production' or 'development' in /etc/make.conf"
	ewarn "Both versions of php.ini can be found in /usr/share/doc/${PF}"

	elog
	elog "For more details on how minor version slotting works (PHP_TARGETS) please read the upgrade guide:"
	elog "https://www.gentoo.org/proj/en/php/php-upgrading.xml"
	elog
}

pkg_prerm() {
	eselect php cleanup
}
