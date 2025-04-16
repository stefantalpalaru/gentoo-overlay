# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Flask-Sphinx-Themes"
MY_P="${MY_PN}-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi

DESCRIPTION="Sphinx Themes for Flask related projects and Flask itself"
HOMEPAGE="https://github.com/pallets/flask-sphinx-themes
		https://pypi.org/project/Flask-Sphinx-Themes/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/flask-sphinx-themes-1.0.2-r3[${PYTHON_USEDEP}]
"
