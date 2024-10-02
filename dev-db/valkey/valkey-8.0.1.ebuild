# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# N.B.: It is no use porting this to Lua eclasses, as upstream have deviated
# too far from vanilla Lua, adding their own APIs like "lua_enablereadonlytable"

inherit autotools edo multiprocessing systemd tmpfiles toolchain-funcs

DESCRIPTION="Redis fork"
HOMEPAGE="
	https://valkey.io
	https://github.com/valkey-io/valkey
"
SRC_URI="https://github.com/valkey-io/valkey/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD Boost-1.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="ssl systemd tcmalloc test"
RESTRICT="!test? ( test )"

# We use the bundled jemalloc because it has been modified to support active defragmentation.

DEPEND="
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tcmalloc? ( dev-util/google-perftools )
"

RDEPEND="
	${DEPEND}
	acct-group/valkey
	acct-user/valkey
"

BDEPEND="
	acct-group/valkey
	acct-user/valkey
	virtual/pkgconfig
	test? (
		dev-lang/tcl:0=
		ssl? ( dev-tcltk/tls )
	)
"

PATCHES=(
	"${FILESDIR}"/valkey-8.0.0-config.patch
	"${FILESDIR}"/valkey-8.0.0-ppc-atomic.patch
	"${FILESDIR}"/valkey-sentinel-8.0.0-config.patch
	"${FILESDIR}"/valkey-8.0.0-no-which.patch
)

src_prepare() {
	default

	# Respect user CFLAGS in bundled lua
	sed -i '/LUA_CFLAGS/s: -O2::g' deps/Makefile || die

	# now we will rewrite present Makefiles
	local makefiles="" MKF
	local mysedconf=(
		-e 's:$(CC):@CC@:g'
		-e 's:$(CFLAGS):@AM_CFLAGS@:g'
		-e 's: $(DEBUG)::g'

		-e 's:-Werror ::g'
		-e 's:-Werror=deprecated-declarations ::g'
	)
	for MKF in $(find -name 'Makefile' | cut -b 3-); do
		mv "${MKF}" "${MKF}.in"
		sed -i "${mysedconf[@]}" "${MKF}.in" || die "Sed failed for ${MKF}"
		makefiles+=" ${MKF}"
	done
	# autodetection of compiler and settings; generates the modified Makefiles
	cp "${FILESDIR}"/configure.ac-8.0 configure.ac || die

	sed -i \
		-e "/^AC_INIT/s|, __PV__, |, $PV, |" \
		-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoreconf
}

src_configure() {
	econf

	# Linenoise can't be built with -std=c99, see https://bugs.gentoo.org/451164
	# also, don't define ANSI/c99 for lua twice
	sed -i -e "s:-std=c99::g" deps/linenoise/Makefile deps/Makefile || die
}

src_compile() {
	tc-export AR CC RANLIB

	local myconf=(
		AR="${AR}"
		CC="${CC}"
		RANLIB="${RANLIB}"

		V=1 # verbose

		# OPTIMIZATION defaults to -O3. Let's respect user CFLAGS by setting it
		# to empty value.
		OPTIMIZATION=''
		# Disable debug flags in bundled hiredis
		DEBUG_FLAGS=''

		BUILD_TLS=$(usex ssl)
		USE_SYSTEMD=$(usex systemd)
	)

	if use tcmalloc; then
		myconf+=( MALLOC=tcmalloc )
	else
		myconf+=( MALLOC=jemalloc )
	fi

	emake "${myconf[@]}"
}

src_test() {
	local runtestargs=(
		--clients "$(makeopts_jobs)" # see bug #649868

		--skiptest "Active defrag eval scripts" # see bug #851654
	)

	if has usersandbox ${FEATURES} || ! has userpriv ${FEATURES}; then
		ewarn "oom-score-adj related tests will be skipped." \
			"They are known to fail with FEATURES usersandbox or -userpriv. See bug #756382."

		runtestargs+=(
			# unit/oom-score-adj was introduced in version 6.2.0
			--skipunit unit/oom-score-adj # see bug #756382

			# Following test was added in version 7.0.0 to unit/introspection.
			# It also tries to adjust OOM score.
			--skiptest "CONFIG SET rollback on apply error"
		)
	fi

	if use ssl; then
		edo ./utils/gen-test-certs.sh
		runtestargs+=( --tls )
	fi

	edo ./runtest "${runtestargs[@]}"
}

src_install() {
	insinto /etc/valkey
	doins valkey.conf sentinel.conf
	use prefix || fowners -R valkey:valkey /etc/valkey /etc/valkey/{valkey,sentinel}.conf
	fperms 0750 /etc/valkey
	fperms 0644 /etc/valkey/{valkey,sentinel}.conf

	newconfd "${FILESDIR}/valkey.confd-r2" valkey
	newinitd "${FILESDIR}/valkey.initd-6" valkey

	systemd_newunit "${FILESDIR}/valkey.service-4" valkey.service
	newtmpfiles "${FILESDIR}/valkey.tmpfiles-2" valkey.conf

	newconfd "${FILESDIR}/valkey-sentinel.confd-r1" valkey-sentinel
	newinitd "${FILESDIR}/valkey-sentinel.initd-r1" valkey-sentinel

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodoc 00-RELEASENOTES CONTRIBUTING.md README.md

	dobin src/valkey-cli
	dosbin src/valkey-benchmark src/valkey-server src/valkey-check-aof src/valkey-check-rdb
	fperms 0750 /usr/sbin/valkey-benchmark
	dosym valkey-server /usr/sbin/valkey-sentinel

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o valkey -g valkey
	fi
	keepdir /var/{log,lib}/valkey
}

pkg_postinst() {
	tmpfiles_process valkey.conf
}
