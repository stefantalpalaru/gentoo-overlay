# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/warner/python-spake2.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://github.com/warner/python-spake2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Python implementation of SPAKE2"
HOMEPAGE="https://github.com/warner/python-spake2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$(python_gen_any_dep '
	dev-python/hkdf[${PYTHON_USEDEP}]
')"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

python_check_deps() {
	has_version "dev-python/hkdf[${PYTHON_USEDEP}]"
}

S="${WORKDIR}/python-${P}"
