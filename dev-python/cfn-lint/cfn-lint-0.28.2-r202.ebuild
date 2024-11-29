# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="CloudFormation Linter"
HOMEPAGE="https://pypi.org/project/cfn-lint/ https://github.com/aws-cloudformation/cfn-python-lint"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/importlib-resources:python2[${PYTHON_USEDEP}]
	dev-python/jsonpatch:python2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6:python2[${PYTHON_USEDEP}]
	>=dev-python/aws-sam-translator-1.19.1:python2[${PYTHON_USEDEP}]
	>=dev-python/pathlib2-2.3.0:python2[${PYTHON_USEDEP}]
	dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.11:python2[${PYTHON_USEDEP}]
	!<dev-python/cfn-lint-0.28.2-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/bin/cfn-lint" "${ED}/usr/bin/cfn-lint_py2"
	mv "${ED}/usr/lib/python-exec/python2.7/cfn-lint" "${ED}/usr/lib/python-exec/python2.7/cfn-lint_py2"
}
