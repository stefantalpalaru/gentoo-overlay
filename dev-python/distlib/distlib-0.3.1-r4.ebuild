# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Low-level components of distutils2/packaging"
HOMEPAGE="https://pypi.org/project/distlib/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="PSF-2"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

# pypiserver is called as external executable
# openpyxl installs invalid metadata that breaks distlib
BDEPEND="
	app-arch/unzip
	test? (
		dev-python/pypiserver
		!<dev-python/openpyxl-3.0.3[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!<dev-python/distlib-0.3.1-r3[${PYTHON_USEDEP}]
"

src_prepare() {
	# make sure they're not used
	rm -r tests/unittest2 || die

	# use system pypiserver instead of broken bundled one
	eapply "${FILESDIR}"/distlib-0.3.1-system-pypiserver.py || die

	# doesn't work with our patched pip
	sed -e '/PIP_AVAIL/s:True:False:' \
		-i tests/test_wheel.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x SKIP_ONLINE=1
	local -x PYTHONHASHSEED=0
	"${EPYTHON}" tests/test_all.py -v ||
		die "Tests failed with ${EPYTHON}"
}
