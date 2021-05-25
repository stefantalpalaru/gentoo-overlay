# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 git-r3 multiprocessing

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
EGIT_REPO_URI="https://github.com/nim-lang/Nim"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="bash-completion boehm-gc doc +readline test"

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

src_unpack() {
	git-r3_src_unpack
	local csources_repo="https://github.com/nim-lang/csources_v1"
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
		-e "s/-w -O3 //" \
		makefile
	emake CC=gcc LD=gcc
	cd ..
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
	# "./koch tools" downloads and builds nimble
	#./koch tools -d:release --listCmd || die "koch tools failed"
	PATH="./bin:${PATH}" nim c --noNimblePath -p:compiler -d:release --listCmd --parallelBuild:$(makeopts_jobs) -o:bin/nimsuggest nimsuggest/nimsuggest.nim || die "nimsuggest compilation failed"
	PATH="./bin:${PATH}" nim c -d:release --listCmd --parallelBuild:$(makeopts_jobs) -o:bin/nimgrep tools/nimgrep.nim || die "nimgrep compilation failed"
	PATH="./bin:${PATH}" nim c -d:release --listCmd --parallelBuild:$(makeopts_jobs) -o:bin/nimpretty nimpretty/nimpretty.nim || die "nimpretty compilation failed"

	if use doc; then
		PATH="./bin:${PATH}" ./koch docs || die "koch docs failed"
	fi
}

src_test() {
	PATH="./bin:${PATH}" ./koch tests || die "tests failed"
}

src_install() {
	./koch install "${D}/usr/share" || die "koch install failed"
	# config files
	mkdir -p "${D}/etc/nim"
	mv "${D}"/usr/share/nim/config/* "${D}/etc/nim/"
	rm -r "${D}/usr/share/nim/config"
	# "compiler" package
	mkdir -p "${D}"/usr/share/nim/lib/packages/compiler
	mv "${D}"/usr/share/nim/{compiler,compiler.nimble} "${D}"/usr/share/nim/lib/packages/compiler/
	# binaries
	dodir /usr/bin
	dosym ../share/nim/bin/nim /usr/bin/nim
	exeinto /usr/bin
	doexe tools/niminst/niminst
	doexe bin/nimsuggest
	doexe bin/nimgrep
	doexe bin/nimpretty
	# nim-gdb
	insinto /usr/share/nim/tools
	doins tools/nim-gdb.py
	sed -i -e "s%^NIM_SYSROOT.*$%NIM_SYSROOT=$EPREFIX/usr/share/nim%" bin/nim-gdb
	doexe bin/nim-gdb
	# modules ignored by `koch install`
	rm -rf doc/nimcache
	insinto /usr/share/nim/lib
	doins -r doc
	insinto /usr/share/nim/lib/wrappers
	doins -r lib/wrappers/linenoise
	# GDB helper
	insinto /usr/share/nim
	doins tools/nim-gdb.py

	if use doc; then
		HTML_DOCS=doc/html/*.html
		einstalldocs
	fi

	if use bash-completion; then
		newbashcomp tools/nim.bash-completion ${PN}
	fi
}
