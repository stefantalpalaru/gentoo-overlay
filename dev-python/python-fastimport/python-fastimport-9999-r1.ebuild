# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1 git-r3

DESCRIPTION="Fastimport parser in Python"
HOMEPAGE="https://github.com/jelmer/python-fastimport"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jelmer/${PN}"

LICENSE="GPL-2+"
SLOT="0"
IUSE="test"

DEPEND="
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" -m unittest -v fastimport.tests.test_suite \
		|| die "Tests fail with ${EPYTHON}"
}
