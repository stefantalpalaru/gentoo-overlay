# Copyright 2008-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
SRC_URI="https://github.com/protocolbuffers/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="0/24"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="emacs examples static-libs test zlib"
RESTRICT="mirror !test? ( test )"

BDEPEND="emacs? ( app-editors/emacs:* )"
DEPEND="test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
RDEPEND="emacs? ( app-editors/emacs:* )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-3.13.0-disable_no-warning-test.patch"
	"${FILESDIR}/${PN}-3.13.0-system_libraries.patch"
	"${FILESDIR}/${PN}-3.13.0-protoc_input_output_files.patch"
)

DOCS=(CHANGES.txt CONTRIBUTORS.txt README.md)

src_prepare() {
	default

	# https://github.com/protocolbuffers/protobuf/issues/7413
	sed -e "/^AC_PROG_CXX_FOR_BUILD$/d" -i configure.ac || die

	# https://github.com/protocolbuffers/protobuf/issues/7682
	sed -e "/^[[:space:]]*static_assert(alignof(T) <= 8, \"T is overaligned, see b\/151247138\");$/d" -i src/google/protobuf/arena.h || die

	eautoreconf
}

src_configure() {
	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI

	if tc-ld-is-gold; then
		# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-force-bfd
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local options=(
		$(use_enable static-libs static)
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# Build system uses protoc when building, so protoc copy runnable on host is needed.
		mkdir -p "${WORKDIR}/build" || die
		pushd "${WORKDIR}/build" > /dev/null || die
		ECONF_SOURCE="${S}" econf_build "${options[@]}"
		options+=(--with-protoc="$(pwd)/src/protoc")
		popd > /dev/null || die
	fi

	ECONF_SOURCE="${S}" econf "${options[@]}"
}

src_compile() {
	multilib-minimal_src_compile

	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

multilib_src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}/build/src" protoc
	fi

	default
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die

	insinto /usr/share/vim/vimfiles/syntax
	doins editors/proto.vim
	insinto /usr/share/vim/vimfiles/ftdetect
	doins "${FILESDIR}/proto.vim"

	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		DOCS+=(examples)
		docompress -x /usr/share/doc/${PF}/examples
	fi

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
