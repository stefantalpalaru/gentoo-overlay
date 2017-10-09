# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit git-r3 python-single-r1 vim-plugin

DESCRIPTION="vim plugin: easy and fast outlining"
HOMEPAGE="https://github.com/vimoutliner/vimoutliner"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vimoutliner/vimoutliner"
EGIT_COMMIT="c13141d604959d84225c3a53dc4b0ef5ae8b2bfe"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="vimoutliner"
VIM_PLUGIN_MESSAGES="filetype"

RDEPEND="dev-python/autopep8"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e '1s:^:#!/usr/bin/python\n:' vimoutliner/scripts/otl2latex/otl2latex.py
	rm -v install.sh || die
	find "${S}" -type f -exec chmod a+r {} \; || die
}

src_compile() {
	local pyscript _pyscript
	for pyscript in $(find "${S}" -type f -name \*.py); do
		_pyscript=$(basename "${pyscript}")
		[ ${_pyscript} == "otl.py" ] && continue
		einfo "Processing ${_pyscript}"
		sed -i -e 's#[ \t]*$##g;' "${pyscript}" || die
		python_is_python3 && (2to3 --no-diffs -w -n "${pyscript}" 2> /dev/null || die)
		autopep8 -i "${pyscript}" || die
		python_fix_shebang -q "${pyscript}"
		eend $?
	done
}
