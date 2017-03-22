# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim is a compiled, garbage-collected systems programming language"
HOMEPAGE="http://nim-lang.org/"
EGIT_REPO_URI="https://github.com/Araq/Nim"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="boehm-gc doc +readline test"

DEPEND="
	readline? ( sys-libs/readline:= )
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	boehm-gc? ( dev-libs/boehm-gc )
"

src_unpack() {
	git-r3_src_unpack
	local csources_repo="https://github.com/nim-lang/csources"
	git-r3_fetch "${csources_repo}"
	git-r3_checkout "${csources_repo}" "${WORKDIR}/${P}/csources"
}

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	cd csources
	#sh build.sh --extraBuildArgs "${CFLAGS}" || die "build.sh failed"
	sed -i \
		-e "s/^COMP_FLAGS =.*$/COMP_FLAGS = ${CFLAGS} -fno-strict-aliasing/" \
		-e "s/^LINK_FLAGS =.*$/LINK_FLAGS = ${LDFLAGS}/" \
		makefile
	emake
	cd ..
	sed -i \
		-e "s/^gcc\.options\.speed.*$/gcc.options.speed = \"${CFLAGS} -fno-strict-aliasing\"/" \
		-e "s/^gcc\.cpp\.options\.speed.*$/gcc.cpp.options.speed = \"${CFLAGS} -fno-strict-aliasing\"/" \
		-e "s/\"-ldl\"/\"-ldl ${LDFLAGS}\"/g" \
		config/nim.cfg
	cat <<EOF >> config/nim.cfg

# Gentoo additions
path="\$lib/compiler"
path="\$lib/packages"
EOF
	./bin/nim c -d:release koch || die "csources nim failed"
	./koch boot -d:release $(nim_use_enable readline useGnuReadline) || die "koch boot failed"
	PATH="./bin:${PATH}" nim c -d:release tools/nimgrep.nim || die "nimgrep.nim compilation failed"
	echo -e "\npath:\"\$projectPath/../..\"" >> compiler/nimfix/nimfix.nim.cfg
	PATH="./bin:${PATH}" nim c -d:release compiler/nimfix/nimfix.nim || die "nimfix.nim compilation failed"

	if use doc; then
		PATH="./bin:${PATH}" ./koch web || die "koch web failed"
	fi
}

src_test() {
	PATH="./bin:${PATH}" ./koch test
}

src_install() {
	./koch install "${D}/usr/share" || die "koch install failed"
	rm -r "${D}/usr/share/nim/doc"
	dodir /usr/bin
	dosym /usr/share/nim/bin/nim /usr/bin/nim
	exeinto /usr/bin
	doexe tools/niminst/niminst
	doexe tools/nimgrep
	doexe compiler/nimfix/nimfix
	insinto /usr/share/nim/lib
	doins -r compiler
	doins -r doc
	insinto /usr/share/nim/lib/wrappers
	doins -r lib/wrappers/linenoise
	rm -r "${D}"/usr/share/nim/lib/compiler/{nimfix/nimcache,nimfix/nimfix,nim,nim0,nim1}

	if use doc; then
		HTML_DOCS=doc/html/*.html
		einstalldocs
	fi
}
