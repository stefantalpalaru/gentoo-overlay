# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit eutils distutils-r1

DESCRIPTION="Set of facilities to extend Python with C++"
HOMEPAGE="http://cxx.sourceforge.net"
SRC_URI="mirror://sourceforge/cxx/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="doc examples"

python_prepare_all() {
	# Without this, pysvn fails.
	# CXX/Python2/Config.hxx: No such file or directory
	#sed -e "/^#include/s:/Python[23]/:/:" -i CXX/*/*.hxx || die "sed failed"
	sed -e "/^#include/s:Src/::" -i Src/*.c{,xx} || die "sed failed"

	# Remove python2 print statement
	echo > Lib/__init__.py || die

	distutils-r1_python_prepare_all
	default
}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/. )
	use examples && local EXAMPLES=( Demo/Python{2,3}/. )
	distutils-r1_python_install_all
}
