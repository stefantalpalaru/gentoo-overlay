# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1 git-r3

DESCRIPTION="SMS/MMS encoder/decoder"
HOMEPAGE="https://github.com/pmarti/python-messaging"
EGIT_REPO_URI="https://github.com/pmarti/python-${PN}"
EGIT_COMMIT="5feb6823896aaae0ddff94a694646464a22b5828"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="python2"
IUSE="test"

RDEPEND="
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	!<dev-python/messaging-0.5.12_p20151120-r200[${PYTHON_USEDEP}]
"
DEPEND="$RDEPEND
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests || die
}
