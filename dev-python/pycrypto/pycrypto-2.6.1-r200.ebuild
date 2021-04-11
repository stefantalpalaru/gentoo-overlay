# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python Cryptography Toolkit"
HOMEPAGE="https://www.dlitz.net/software/pycrypto/
	https://pypi.org/project/pycrypto/"
SRC_URI="http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/${P}.tar.gz"

LICENSE="PSF-2 public-domain"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +gmp test"
RESTRICT="!test? ( test )"

RDEPEND="gmp? ( dev-libs/gmp:0= )
	!<dev-python/pycrypto-2.6.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		>=dev-python/epydoc-3[${PYTHON_USEDEP}]
	)"

REQUIRED_USE="test? ( gmp )"

DOCS=( ACKS ChangeLog README TODO )
PATCHES=(
	"${FILESDIR}"/${P}-cross-compile.patch
	"${FILESDIR}"/${P}-CVE-2013-7459.patch
)

python_prepare_all() {
	# Fix Crypto.PublicKey.RSA._RSAobj.exportKey(format="OpenSSH") with Python 3
	# https://github.com/dlitz/pycrypto/commit/ab25c6fe95ee92fac3187dcd90e0560ccacb084a
	sed \
		-e "/keyparts =/s/'ssh-rsa'/b('ssh-rsa')/" \
		-e "s/keystring = ''.join/keystring = b('').join/" \
		-e "s/return 'ssh-rsa '/return b('ssh-rsa ')/" \
		-i lib/Crypto/PublicKey/RSA.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# the configure does not interact with python in any way,
	# it just sets up the C header file.
	econf \
		$(use_with gmp) \
		--without-mpir
}

python_compile_all() {
	if use doc; then
		rst2html.py Doc/pycrypt.rst > Doc/index.html || die
		epydoc --config=Doc/epydoc-config --exclude-introspect="^Crypto\.(Random\.OSRNG\.nt|Util\.winrandom)$" || die
		HTML_DOCS=( Doc/apidoc/. Doc/index.html )
	fi
}

python_compile() {
	local -x CFLAGS="${CFLAGS}"
	append-cflags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}
