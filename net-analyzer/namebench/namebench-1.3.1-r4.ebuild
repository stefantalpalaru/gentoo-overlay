# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="DNS Benchmark Utility"
HOMEPAGE="https://github.com/google/namebench"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/namebench/namebench-${PV}-source.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

# PYTHON_REQ_USE does not support X? ( tk ) syntax yet
DEPEND="X? ( $(python_gen_cond_dep "dev-lang/python:2.7[tk]" -2) )"
RDEPEND="${DEPEND}
	dev-python/dnspython[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.6[${PYTHON_USEDEP}]
	>=dev-python/graphy-1.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.1.2[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# don't include bundled libraries
	export NO_THIRD_PARTY=1

	distutils-r1_python_prepare_all
}

python_install() {
	#set prefix
	distutils-r1_python_install --install-data=/usr/share
}

python_install_all() {
	dosym ${PN}.py /usr/bin/${PN}
	distutils-r1_python_install_all
}
