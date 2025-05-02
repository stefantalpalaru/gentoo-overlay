# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
MY_COMMIT="d0455c7d41"

inherit python-single-r1

DESCRIPTION="Internet radio browser"
HOMEPAGE="http://freshcode.club/projects/streamtuner2
		https://fossil.include-once.org/streamtuner2/index"
SRC_URI="https://fossil.include-once.org/streamtuner2/tarball/${MY_COMMIT}/streamtuner2-${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror"

DEPEND="$(python_gen_cond_dep '
	dev-python/pillow:0[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyquery:0[${PYTHON_USEDEP}]
	dev-python/requests:0[${PYTHON_USEDEP}]
')"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}"/streamtuner2-2.2.2-python3.13.patch
)

src_prepare() {
	default
	sed -i \
		-e "s/^VERSION :=.*$/VERSION := ${PV}/" \
		Makefile || die
	gunzip -k gtk3.xml.gz
	find -name '*.pyc' -delete
	rm -rf bundle/__pycache__
}

src_compile() {
	:
}

src_install() {
	python_fix_shebang -f bin
	exeinto /usr/bin
	newexe bin st2.py
	dosym st2.py /usr/bin/${PN}

	insinto /usr/share/pixmaps
	doins streamtuner2.png

	insinto /usr/share/${PN}
	doins -r .
	rm -rf "${D}/usr/share/${PN}/contrib/disabled"
	mv "${D}/usr/share/${PN}/pluginconf"/* "${D}/usr/share/${PN}/" || die
	rm -rf "${D}/usr/share/${PN}/pluginconf"
	python_optimize "${D}/usr/share/${PN}"
}
