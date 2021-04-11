# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=cfn-lint
MY_P=${MY_PN}-${PV}
DESCRIPTION="CloudFormation Linter"
HOMEPAGE="https://pypi.org/project/cfn-lint/ https://github.com/aws-cloudformation/cfn-python-lint"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/importlib_resources:python2[${PYTHON_USEDEP}]
	dev-python/jsonpatch:python2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6:python2[${PYTHON_USEDEP}]
	>=dev-python/aws-sam-translator-1.19.1:python2[${PYTHON_USEDEP}]
	>=dev-python/pathlib2-2.3.0:python2[${PYTHON_USEDEP}]
	dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.11:python2[${PYTHON_USEDEP}]
	!<dev-python/cfn-python-lint-0.28.2-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
S=${WORKDIR}/${MY_P}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/bin/cfn-lint" "${ED}/usr/bin/cfn-lint_py2"
	mv "${ED}/usr/lib/python-exec/python2.7/cfn-lint" "${ED}/usr/lib/python-exec/python2.7/cfn-lint_py2"
}
