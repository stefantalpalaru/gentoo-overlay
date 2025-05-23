# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python port of Perl module Directory::Queue"
HOMEPAGE="https://github.com/cern-mig/python-dirq"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Note: as of 2017-03-22, dirq tests are known to fail in Docker containers
python_test() {
	esetup.py test
}
