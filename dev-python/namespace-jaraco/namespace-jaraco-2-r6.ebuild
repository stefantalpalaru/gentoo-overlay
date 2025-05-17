# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 python3_{10..14} )
inherit python-r1

DESCRIPTION="Namespace package declaration for jaraco"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	!<dev-python/jaraco-packaging-5.1
	${PYTHON_DEPS}
"
DEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	mkdir -p "${S}"/jaraco || die
	cat > "${S}"/jaraco/__init__.py <<-EOF || die
		__path__ = __import__('pkgutil').extend_path(__path__, __name__)
	EOF
}

src_install() {
	python_foreach_impl python_domodule jaraco
}
