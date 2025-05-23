# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Identify specific nodes in a JSON document (according to draft 08)"
HOMEPAGE="https://github.com/stefankoegl/python-json-pointer
		https://pypi.org/project/jsonpointer/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/jsonpointer-2.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	mv bin/jsonpointer bin/jsonpointer_py2
	sed -i \
		-e 's#bin/jsonpointer#bin/jsonpointer_py2#' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
}
