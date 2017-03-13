# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="SMS/MMS encoder/decoder"
HOMEPAGE="https://github.com/pmarti/python-messaging"
EGIT_REPO_URI="https://github.com/pmarti/python-${PN}"
EGIT_COMMIT="5feb6823896aaae0ddff94a694646464a22b5828"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="$RDEPEND
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests || die
}
