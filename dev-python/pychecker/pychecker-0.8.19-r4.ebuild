# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python source code checking tool"
HOMEPAGE="http://pychecker.sourceforge.net/ https://pypi.org/project/PyChecker/"
SRC_URI="https://downloads.sourceforge.net/pychecker/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="test"
DOCS=( pycheckrc ChangeLog KNOWN_BUGS MAINTAINERS NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-version.patch
	"${FILESDIR}"/${P}-create_script.patch
)

python_prepare_all() {
	sed \
		-e '1d' \
		-i pychecker/checker.py \
		|| die

	# Disable installation of unneeded files.
	sed \
		-e "/'data_files'       :/d" \
		-i setup.py || die "sed failed"

	# Strip final "/" from root.
	sed \
		-e 's:root = self\.distribution\.get_command_obj("install")\.root:&\.rstrip("/"):' \
		-i setup.py || die "sed failed"

	distutils-r1_python_prepare_all
}
