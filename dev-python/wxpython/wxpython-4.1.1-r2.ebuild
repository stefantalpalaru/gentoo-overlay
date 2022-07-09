# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{8..11} )
WX_GTK_VER="3.1-gtk3"
DISTUTILS_IN_SOURCE_BUILD=1
DISTUTILS_USE_SETUPTOOLS="manual"

inherit distutils-r1 multiprocessing virtualx wxwidgets

MY_PN="wxPython"
MY_PV="${PV}"

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="https://www.wxpython.org/
		https://github.com/wxWidgets/Phoenix"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="4.0"
KEYWORDS="~alpha ~amd64 arm arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test webkit"
RESTRICT="!test? ( test )"

# wxPython doesn't seem to be able to optionally disable features. webkit is
# optionally patched out because it's so huge, but other elements are not,
# which makes us have to require all features from wxGTK
RDEPEND="
	>=x11-libs/wxGTK-3.1.4:${WX_GTK_VER}=[gstreamer,libnotify,opengl,sdl,tiff,webkit?,X]
	media-libs/libpng:0=
	media-libs/tiff:0
	media-libs/libjpeg-turbo:0"

DEPEND="${RDEPEND}
	app-doc/doxygen
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
	$(python_gen_cond_dep 'dev-python/six:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/six:0[${PYTHON_USEDEP}]' -3)
	test? (
		${VIRTUALX_DEPEND}
		$(python_gen_cond_dep 'dev-python/appdirs:python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/appdirs:0[${PYTHON_USEDEP}]' -3)
		$(python_gen_cond_dep 'dev-python/numpy-python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' -3)
		$(python_gen_cond_dep 'dev-python/pillow:python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/pillow:0[${PYTHON_USEDEP}]' -3)
		$(python_gen_cond_dep 'dev-python/pytest:python2[${PYTHON_USEDEP}]' -2)
		$(python_gen_cond_dep 'dev-python/pytest:0[${PYTHON_USEDEP}]' -3)
	)"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.0-skip-broken-tests.patch"
	"${FILESDIR}/${PN}-4.1.1-override.patch"
)

python_prepare_all() {
	if ! use webkit; then
		eapply "${FILESDIR}/${PN}-4.0.6-no-webkit.patch"
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
	DOXYGEN=/usr/bin/doxygen ${PYTHON} build.py dox etg --nodoc || die
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
