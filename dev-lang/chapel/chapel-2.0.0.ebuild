# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_MAX_SLOT=17

inherit llvm multiprocessing

DESCRIPTION="Chapel programming language compiler"
HOMEPAGE="https://chapel-lang.org/
		https://github.com/chapel-lang/chapel"
SRC_URI="https://github.com/chapel-lang/chapel/releases/download/${PV}/chapel-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test vim-syntax"
RESTRICT="
	strip
	test? ( network-sandbox )
	!test? ( test )
"
DEPEND="
	dev-lang/perl
	dev-lang/python
	dev-libs/gmp
	vim-syntax? ( app-vim/chapel-syntax )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/chapel-2.0.0-no-default-config.patch
)

src_prepare() {
	default

	export CHPL_TASKS=qthreads
	export CHPL_TARGET_COMPILER=llvm
	export CHPL_LLVM=system
	export CHPL_RE2=bundled
	export CHPL_GMP=system
	export CHPL_UNWIND=bundled
}

src_configure() {
	unset CHPL_HOME
	unset CHPL_LLVM_CONFIG
	source util/setchplenv.bash
	./configure --prefix="${EPREFIX}/usr"
}

src_compile() {
	emake VERBOSE=1
	emake VERBOSE=1 check
}

src_install() {
	default

	# "${CHPL_HOME}/util/printchplenv" gets confused about some build options,
	# for a --prefix install, so we put them in the environment.
	local envd="${T}/90chapel"
	cat > "${envd}" <<-EOF
		CHPL_HOME="${EPREFIX}/usr/share/chapel/$(ver_cut 1-2)"
		CHPL_LLVM_CONFIG="$(get_llvm_prefix ${LLVM_MAX_SLOT})/bin/llvm-config"
		CHPL_RE2=bundled
		CHPL_GMP=system
		CHPL_UNWIND=bundled
	EOF
	doenvd "${envd}"
}

src_test() {
	emake test-venv
	cd examples
	mkdir Logs
	# This test runner's exit code is always zero.
	../util/test/paratest.local -dirs . -nodepara $(makeopts_jobs)
	grep -q '#Failures = 0' Logs/portage.linux64.log.summary || die
}

pkg_postinst() {
	elog "
/etc/env.d is updated during ${PN} installation. Please run:\n
'env-update && source /etc/profile'
"
}
