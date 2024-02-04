# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{10..12} )
PYPI_NO_NORMALIZE=1
PYPI_PN="wxPython"
WX_GTK_VER="3.2-gtk3"

inherit distutils-r1 multiprocessing pypi virtualx wxwidgets

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="https://www.wxpython.org/
		https://github.com/wxWidgets/Phoenix"

LICENSE="wxWinLL-3"
SLOT="4.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="test webkit"
RESTRICT="!test? ( test )"

# wxPython doesn't seem to be able to optionally disable features. webkit is
# optionally patched out because it's so huge, but other elements are not,
# which makes us have to require all features from wxGTK
RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}=[gstreamer,libnotify,opengl,sdl,tiff,webkit?,X]
	media-libs/libpng:0=
	media-libs/tiff:0
	media-libs/libjpeg-turbo:0"

DEPEND="${RDEPEND}"
BDEPEND="
	app-text/doxygen
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools:0[${PYTHON_USEDEP}]
	>=dev-python/sip-6.6.2[${PYTHON_USEDEP}]
	dev-python/six:0[${PYTHON_USEDEP}]
	test? (
		${VIRTUALX_DEPEND}
		dev-python/appdirs:0[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow:0[${PYTHON_USEDEP}]
		dev-python/pytest:0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/wxpython-4.1.0-skip-broken-tests.patch"
	"${FILESDIR}/wxpython-4.2.0-flags.patch"
	"${FILESDIR}/wxpython-4.2.0-cython-3.0.0.patch"
)

python_prepare_all() {
	if ! use webkit; then
		eapply "${FILESDIR}/${PN}-4.1.2-no-webkit.patch"
		rm unittests/test_webview.py || die
	fi
	# Most of these tests disabled below fail because of the virtx/portage
	# environment, but some fail for unknown reasons.
	rm unittests/test_uiaction.py \
		unittests/test_notifmsg.py \
		unittests/test_mousemanager.py \
		unittests/test_display.py \
		unittests/test_pi_import.py \
		unittests/test_lib_agw_thumbnailctrl.py \
		unittests/test_sound.py || die

	distutils-r1_python_prepare_all
}

src_configure() {
	setup-wxwidgets
}

python_compile() {
	# build the docs
	DOXYGEN=/usr/bin/doxygen ${PYTHON} build.py dox etg --nodoc || die

	# regenerate Sip bindings
	${PYTHON} build.py sip || die

	# build the bindings
	${PYTHON} build.py build_py \
		--use_syswx \
		--no_magic \
		--jobs=$(makeopts_jobs) \
		--verbose \
		--release || die
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_test() {
	virtx pytest -vv unittests
}
