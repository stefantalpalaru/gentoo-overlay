# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="An implementation of the ACME protocol"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"
SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> certbot-${PV}.gh.tar.gz"
S="${WORKDIR}/certbot-${PV}/acme"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/cryptography-1.3.4:python2[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.1.0:python2[${PYTHON_USEDEP}]
	dev-python/mock:python2[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15.1:python2[${PYTHON_USEDEP}]
	dev-python/pyrfc3339:python2[${PYTHON_USEDEP}]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.3.0:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0:python2[${PYTHON_USEDEP}]
	!<app-crypt/acme-1.8.0-r2[${PYTHON_USEDEP}]
"
DEPEND="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

src_compile() {
	python_foreach_impl run_in_build_dir default
	distutils-r1_src_compile
	if use doc ; then
		cd docs || die
		sphinx-build -b html -d _build/doctrees   . _build/html
	fi
}

python_test() {
	nosetests -w ${PN} || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
