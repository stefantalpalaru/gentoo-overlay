# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_COMPAT=( 17 18 19 20 )
PYTHON_COMPAT=( python3_{10..12} )

inherit llvm-r1 multiprocessing python-any-r1

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
	mirror
"

DEPEND="
	dev-lang/perl
	dev-libs/gmp
	dev-libs/jemalloc
	sys-libs/libunwind
	vim-syntax? ( app-vim/chapel-syntax )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/chapel-2.0.0-no-default-config.patch
	"${FILESDIR}"/chapel-2.4.0-jemalloc.patch
)

pkg_setup() {
	llvm-r1_pkg_setup
}

src_prepare() {
	default

	export CHPL_TASKS=qthreads
	export CHPL_TARGET_COMPILER=llvm
	export CHPL_HOST_COMPILER=llvm
	export CHPL_LLVM=system
	export CHPL_LLVM_CONFIG="$(get_llvm_prefix)/bin/llvm-config"
	export CHPL_LLVM_GCC_INSTALL_DIR=none
	export CHPL_RE2=bundled
	export CHPL_GMP=system
	# System hwloc is usually linked to libudev which tries to access the
	# X.org socket for the :0 display, resulting in an error message messing
	# our tests.
	# This bundled version is built without libudev support.
	export CHPL_HWLOC=bundled
	export CHPL_UNWIND=system
	export CHPL_HOST_JEMALLOC=system
	export CHPL_TARGET_JEMALLOC=system

	export XAUTHORITY=~/.Xauthority
}

src_configure() {
	unset CHPL_HOME
	unset CHPL_LLVM_CONFIG
	source util/setchplenv.bash

	./configure --prefix="${EPREFIX}/usr"
}

src_compile() {
	unset CHPL_HOME
	emake VERBOSE=1

	#export CHPL_CHECK_DEBUG=1
	emake VERBOSE=1 check
}

src_install() {
	default

	# "${CHPL_HOME}/util/printchplenv" gets confused about some build options,
	# for a --prefix install, so we put them in the environment.
	local envd="${T}/90chapel"
	cat > "${envd}" <<-EOF
		CHPL_HOME="${EPREFIX}/usr/share/chapel/$(ver_cut 1-2)"
		CHPL_LLVM_CONFIG="$(get_llvm_prefix)/bin/llvm-config"
		CHPL_RE2=bundled
		CHPL_GMP=system
		CHPL_HWLOC=bundled
		CHPL_UNWIND=system
	EOF
	doenvd "${envd}"
}

src_test() {
	unset CHPL_HOME
	unset CHPL_LLVM_CONFIG
	source util/setchplenv.bash

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
