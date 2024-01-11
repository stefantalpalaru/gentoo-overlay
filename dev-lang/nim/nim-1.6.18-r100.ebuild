# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 multiprocessing

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
SRC_URI="https://nim-lang.org/download/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="bash-completion boehm-gc +readline test" # "doc" is broken
RESTRICT="!test? ( test )"

DEPEND="
	readline? ( sys-libs/readline:= )
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	boehm-gc? ( dev-libs/boehm-gc )
"
BDEPEND="
	test? ( net-libs/nodejs )
"

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	sed -i \
		-e "s/-w -fmax-errors=3 -O3 //" \
		makefile || die
	emake CC=gcc LD=gcc
	sed -i \
		-e "s/^gcc\.options\.speed.*$/gcc.options.speed = \"${CFLAGS} -fno-strict-aliasing\"/" \
		-e "s/^gcc\.cpp\.options\.speed.*$/gcc.cpp.options.speed = \"${CFLAGS} -fno-strict-aliasing\"/" \
		-e "s/\"-ldl\"/\"-ldl ${LDFLAGS}\"/g" \
		config/nim.cfg
	cat <<EOF >> config/nim.cfg

# Gentoo additions
path="\$lib/packages"
EOF
	./bin/nim c -d:release --listCmd --parallelBuild:$(makeopts_jobs) koch || die "csources nim failed"
	./koch boot -d:release --listCmd --parallelBuild:$(makeopts_jobs) $(nim_use_enable readline useGnuReadline) || die "koch boot failed"
	#echo -e "\npath:\"\$projectPath/../..\"" >> compiler/nimfix/nimfix.nim.cfg
	#PATH="./bin:${PATH}" nim c -d:release compiler/nimfix/nimfix.nim || die "nimfix.nim compilation failed"
	PATH="./bin:${PATH}" nim c --noNimblePath -p:compiler -d:release --listCmd --parallelBuild:$(makeopts_jobs) -o:bin/nimsuggest nimsuggest/nimsuggest.nim || die "nimsuggest compilation failed"
	PATH="./bin:${PATH}" nim c -d:release --listCmd --parallelBuild:$(makeopts_jobs) -o:bin/nimgrep tools/nimgrep.nim || die "nimgrep compilation failed"
	PATH="./bin:${PATH}" nim c -d:release --listCmd --parallelBuild:$(makeopts_jobs) -o:bin/nimpretty nimpretty/nimpretty.nim || die "nimpretty compilation failed"

	#if use doc; then
		#PATH="./bin:${PATH}" ./koch docs || die "koch docs failed"
	#fi
}

src_test() {
	PATH="./bin:${PATH}" ./koch tests || die "tests failed"
}

src_install() {
	./koch install "${ED}/usr/share" || die "koch install failed"
	# config files
	mkdir -p "${ED}/etc/nim"
	mv "${ED}"/usr/share/nim/config/* "${ED}/etc/nim/"
	rm -r "${ED}/usr/share/nim/config"
	# "compiler" package
	mkdir -p "${ED}"/usr/share/nim/lib/packages/compiler
	mv "${ED}"/usr/share/nim/{compiler,nim.nimble} "${ED}"/usr/share/nim/lib/packages/compiler/ || die
	# binaries
	dodir /usr/bin
	dosym ../share/nim/bin/nim /usr/bin/nim
	exeinto /usr/bin
	doexe tools/niminst/niminst
	doexe bin/nimsuggest
	doexe bin/nimgrep
	doexe bin/nimpretty
	# modules ignored by `koch install`
	rm -rf doc/nimcache
	insinto /usr/share/nim/lib
	doins -r doc
	insinto /usr/share/nim/lib/wrappers
	doins -r lib/wrappers/linenoise
	# GDB helper
	insinto /usr/share/nim
	doins tools/nim-gdb.py

	#if use doc; then
		#HTML_DOCS=doc/html/*.html
		#einstalldocs
	#fi

	if use bash-completion; then
		newbashcomp tools/nim.bash-completion ${PN}
	fi
}
