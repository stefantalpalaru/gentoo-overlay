# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{10..12} )
PYPI_NO_NORMALIZE=1
PYPI_PN=scikits.example

inherit pypi python-r1

DESCRIPTION="Common files for python scikits"
HOMEPAGE="http://projects.scipy.org/scipy/scikits"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	python_moduleinto scikits
	python_foreach_impl python_domodule scikits.example*/scikits/__init__.py

	if use examples; then
		dodoc -r scikits.example*/*
	fi
}
