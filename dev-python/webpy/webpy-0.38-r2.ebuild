# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="web.py"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="A small and simple web framework for Python"
HOMEPAGE="http://www.webpy.org
	https://pypi.org/project/web.py/"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~amd64-linux ~x86-linux"

python_test() {
	local t
	for t in db http net template utils; do
		einfo "Running doctests in ${t}.py..."
		"${EPYTHON}" web/${t}.py || die "Test ${t} failed with ${EPYTHON}"
	done
}
