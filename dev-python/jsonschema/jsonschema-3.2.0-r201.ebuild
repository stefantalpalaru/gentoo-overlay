# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1 pypi

DESCRIPTION="An implementation of JSON-Schema validation for Python"
HOMEPAGE="https://pypi.org/project/jsonschema/
			https://github.com/Julian/jsonschema"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

CDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/pyrsistent[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	dev-python/functools32[${PYTHON_USEDEP}]
"
BDEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}
	dev-python/idna[${PYTHON_USEDEP}]
	>=dev-python/jsonpointer-1.13[${PYTHON_USEDEP}]
	dev-python/rfc3987[${PYTHON_USEDEP}]
	dev-python/strict-rfc3339[${PYTHON_USEDEP}]
	dev-python/webcolors[${PYTHON_USEDEP}]
	dev-python/rfc3986-validator[${PYTHON_USEDEP}]
	dev-python/rfc3339-validator[${PYTHON_USEDEP}]
	!<dev-python/jsonschema-3.2.0-r2[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-add-webcolors-1.11-compat.patch
)

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i \
		-e "s:setuptools_scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+|)[[:space:]]*::" \
		-e 's/jsonschema = jsonschema.cli:main/jsonschema_py2 = jsonschema.cli:main/' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}
