# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base git-r3

DESCRIPTION="Nim (formerly known as 'Nimrod') is a compiled, garbage-collected systems programming language"
HOMEPAGE="http://nim-lang.org/"
SRC_URI="http://nim-lang.org/download/${P}.zip"
EGIT_REPO_URI="https://github.com/Araq/Nim"
EGIT_COMMIT="refs/tags/v${PV}"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boehm-gc +readline test" # 'doc' is broken because 'nim doc2 ... lib/impure/dialogs.nim' wants to import 'glib2' and 'gtk2'

DEPEND="
	readline? ( sys-libs/readline )
	sys-libs/zlib
"
RDEPEND="
	boehm-gc? ( dev-libs/boehm-gc )
"

src_unpack() {
	base_src_unpack
	mv ${P} ${PN}-csources-${PV}
	git-r3_src_unpack
	mv ${PN}-csources-${PV} ${P}/csources
}

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	cd csources && sh build.sh --extraBuildArgs "${CFLAGS}" || die "build.sh failed"
	cd ..
	sed -i -e "s/^gcc\.options\.speed.*$/gcc.options.speed = \"${CFLAGS}\"/" \
		-e "s/^gcc\.cpp\.options\.speed.*$/gcc.cpp.options.speed = \"${CFLAGS}\"/" \
		-e "s/\"-ldl\"/\"-ldl ${LDFLAGS}\"/g" config/nim.cfg
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

	#if use doc; then
		#PATH="./bin:${PATH}" ./koch web || die "koch web failed"
	#fi
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
	rm -r "${D}"/usr/share/nim/lib/compiler/{nimcache,nimfix/nimcache,nimfix/nimfix,nimsuggest,nim,nim0,nim1}

	#if use doc; then
		#dohtml doc/*.html
	#fi
}
