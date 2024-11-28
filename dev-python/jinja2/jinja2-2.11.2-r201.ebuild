# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A full-featured template engine for Python"
HOMEPAGE="https://jinja.palletsprojects.com/
		https://github.com/pallets/jinja/
		https://pypi.org/project/Jinja2/"
# pypi tarball is missing tests
SRC_URI="https://github.com/pallets/jinja/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/jinja-${PV}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="examples"
RESTRICT="test"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]
	!dev-python/jinja2:compat"

distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/pallets-sphinx-themes

# XXX: handle Babel better?

src_prepare() {
	# avoid unnecessary dep on extra sphinxcontrib modules
	sed -i '/sphinxcontrib.log_cabinet/ d' docs/conf.py || die

	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile

	if ! python_is_python3; then
		rm "${BUILD_DIR}"/lib/jinja2/async*.py || die
	fi
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
	if use examples ; then
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	if ! has_version dev-python/babel; then
		elog "For i18n support, please emerge dev-python/babel."
	fi
}
