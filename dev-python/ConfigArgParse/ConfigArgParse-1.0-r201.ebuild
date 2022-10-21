# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ConfigArgParse"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for argparse supporting config files and env variables"
HOMEPAGE="https://github.com/bw2/ConfigArgParse
	https://pypi.org/project/ConfigArgParse/"
SRC_URI="https://github.com/bw2/ConfigArgParse/archive/${PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/pyyaml:python2[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/ConfigArgParse-1.0-r2[${PYTHON_USEDEP}]
"

python_test() {
	local -x COLUMNS=80
	esetup.py test
}
