# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

# Commit of the Brotli library bundled within brotlipy.
BROTLI_BUNDLED_COMMIT="46c1a881b41bb638c76247558aa04b1591af3aa7"

DESCRIPTION="Python binding to the Brotli library"
HOMEPAGE="https://github.com/python-hyper/brotlipy/
		https://pypi.python.org/pypi/brotlipy"
SRC_URI="
	https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/google/brotli/archive/${BROTLI_BUNDLED_COMMIT}.tar.gz -> brotli-${BROTLI_BUNDLED_COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
RESTRICT="test"

# module name collision with app-arch/brotli
RDEPEND="
	virtual/python-cffi[${PYTHON_USEDEP}]
	!app-arch/brotli[python]
	!<dev-python/brotlipy-0.7.0-r5[${PYTHON_USEDEP}]
"

S="${WORKDIR}/brotlicffi-${PV}"

src_prepare() {
	# Inject the brotli lib.
	rm -r "${WORKDIR}/brotlicffi-${PV}/libbrotli" || die "Could not remove the bundled brotli lib folder."
	cp -r "${WORKDIR}/brotli-${BROTLI_BUNDLED_COMMIT}/" "${WORKDIR}/brotlicffi-${PV}/libbrotli" || die "Could not inject the brotli lib."

	# Tests fail if we have this folder preserved within the lib.
	rm -r "${WORKDIR}/brotlicffi-${PV}/libbrotli/python" || die "Could not remove 'python' subfolder."

	distutils-r1_src_prepare
}
