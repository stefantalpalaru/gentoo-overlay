# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library that performs advanced searches in strings"
HOMEPAGE="https://github.com/Toilal/rebulk
		https://pypi.org/project/rebulk/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/rebulk-2.0.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# Remove base64-encoded zip archive with pytest.
	rm runtests.py || die

	# Disable unconditional dependency on dev-python/pytest-runner.
	sed -i -e "s|'pytest-runner'||g" setup.py || die

	distutils-r1_python_prepare_all
}
