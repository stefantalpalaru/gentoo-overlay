# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python Documentation Utilities"
HOMEPAGE="https://docutils.sourceforge.net/
		https://pypi.org/project/docutils/"
LICENSE="BSD-2 GPL-3 public-domain"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<dev-python/docutils-0.16-r3[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-tests.patch
)

python_prepare_all() {
	for F in tools/*.py; do
		mv "${F}" "${F%.py}_py2.py"
	done
	sed -i \
		-e "s%'tools/\(.*\)\.py'%'tools/\1_py2.py'%" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Generate html docs from reStructured text sources.

	# Place html4css1.css in base directory to ensure that the generated reference to it is correct.
	cp docutils/writers/html4css1/html4css1.css . || die

	cd tools || die
	"${EPYTHON}" buildhtml_py2.py --input-encoding=utf-8 \
		--stylesheet-path=../html4css1.css, --traceback ../docs || die
}

src_test() {
	cd test || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" alltests.py -v || die "Testing failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# Install tools.
	python_doscript tools/{buildhtml,quicktest}_py2.py
}

install_txt_doc() {
	local doc="${1}"
	local dir="txt/$(dirname ${doc})"
	docinto "${dir}"
	dodoc "${doc}"
}

python_install_all() {
	local DOCS=( *.txt )
	local HTML_DOCS=( docs tools docutils/writers/html4css1/html4css1.css )

	distutils-r1_python_install_all

	local doc
	while IFS= read -r -d '' doc; do
		install_txt_doc "${doc}"
	done < <(find docs tools -name '*.txt' -print0)
}
