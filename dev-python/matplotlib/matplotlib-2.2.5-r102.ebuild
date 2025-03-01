# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='tk?,threads(+)'
PYPI_PN="${PN/-python2}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 flag-o-matic pypi virtualx toolchain-funcs prefix

MY_PN=${PN/-python2}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Pure python plotting library with matlab like syntax (py2 version)"
HOMEPAGE="https://matplotlib.org/
		https://github.com/matplotlib/matplotlib"
S=${WORKDIR}/${MY_P}
# Main license: matplotlib
# Some modules: BSD
# matplotlib/backends/qt4_editor: MIT
# Fonts: BitstreamVera, OFL-1.1
LICENSE="BitstreamVera BSD matplotlib MIT OFL-1.1"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="cairo excel gtk2 gtk3 latex qt5 test tk wxwidgets"

PY2_FLAGS="|| ( $(python_gen_useflags python2_7) )"
REQUIRED_USE="
	excel? ( ${PY2_FLAGS} )
	gtk2? ( ${PY2_FLAGS} )
	wxwidgets? ( ${PY2_FLAGS} )
	test? (
		cairo latex qt5 tk wxwidgets
		|| ( gtk2 gtk3 )
		)"

# #456704 -- a lot of py2-only deps
PY2_DEPEND="
	dev-python/functools32[${PYTHON_USEDEP}]
	dev-python/subprocess32[${PYTHON_USEDEP}]
	dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7.1:python2[${PYTHON_USEDEP}]
"
COMMON_DEPEND="
	dev-python/cycler:python2[${PYTHON_USEDEP}]
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10:python2[${PYTHON_USEDEP}]
	media-fonts/stix-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	>=media-libs/qhull-2015.2
	>=dev-python/kiwisolver-1.0.0:python2[${PYTHON_USEDEP}]
	cairo? ( dev-python/cairocffi:python2[${PYTHON_USEDEP}] )
	gtk2? (
		dev-libs/glib:2=
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		dev-python/pygtk[${PYTHON_USEDEP}] )
	wxwidgets? ( >=dev-python/wxpython-2.8:*[${PYTHON_USEDEP}] )"

# internal copy of pycxx highly patched
#	dev-python/pycxx

DEPEND="${COMMON_DEPEND}
	${PY2_DEPEND}
	dev-python/versioneer[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/nose-0.11.1[${PYTHON_USEDEP}]
		)"

RDEPEND="${COMMON_DEPEND}
	${PY2_DEPEND}
	>=dev-python/pyparsing-1.5.6[${PYTHON_USEDEP}]
	excel? ( dev-python/xlwt[${PYTHON_USEDEP}] )
	gtk3? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection] )
	latex? (
		virtual/latex-base
		app-text/ghostscript-gpl
		app-text/dvipng
		app-text/poppler[utils]
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-xetex
	)
	qt5? ( dev-python/pyqt5[gui,widgets,${PYTHON_USEDEP}] )"

# A few C++ source files are written to srcdir.
# Other than that, the ebuild shall be fit for out-of-source build.
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/matplotlib-2.2.4-doc-fix.patch
	"${FILESDIR}"/matplotlib-2.2.4-delete-objects.patch
)

pkg_setup() {
	unset DISPLAY # bug #278524
}

use_setup() {
	local uword="${2:-${1}}"
	if use ${1}; then
		echo "${uword} = True"
		echo "${uword}agg = True"
	else
		echo "${uword} = False"
		echo "${uword}agg = False"
	fi
}

python_prepare_all() {
	sed \
		-e 's/matplotlib.pyparsing_py[23]/pyparsing/g' \
		-i lib/matplotlib/{mathtext,fontconfig_pattern}.py \
		|| die "sed pyparsing failed"

	hprefixify setupext.py

	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
	append-cppflags -DNDEBUG  # or get old trying to do triangulation
	tc-export PKG_CONFIG
}

python_configure() {
	mkdir -p "${BUILD_DIR}" || die

	# create setup.cfg (see setup.cfg.template for any changes).

	# common switches.
	cat > "${BUILD_DIR}"/setup.cfg <<- EOF || die
		[directories]
		basedirlist = "${EPREFIX}/usr"
		[provide_packages]
		pytz = False
		dateutil = False
		[packages]
		tests = $(usex test True False)
		[gui_support]
		agg = True
		pyside = False
		pysideagg = False
		qt4 = False
		qt4agg = False
		$(use_setup cairo)
		$(use_setup gtk3)
		$(use_setup qt5)
		$(use_setup tk)
	EOF

	if use gtk3 && use cairo; then
		echo "gtk3cairo = True" >> "${BUILD_DIR}"/setup.cfg || die
	else
		echo "gtk3cairo = False" >> "${BUILD_DIR}"/setup.cfg || die
	fi

	cat >> "${BUILD_DIR}"/setup.cfg <<-EOF || die
		$(use_setup gtk2 gtk)
		$(use_setup wxwidgets wx)
	EOF
}

wrap_setup() {
	# "py_converters.o" is used by multiple extensions, but needs to be compiled with different defines.
	# See also "matplotlib-2.2.4-delete-objects.patch".
	local MAKEOPTS=-j1
	local -x MPLSETUPCFG=${BUILD_DIR}/setup.cfg
	unset DISPLAY
	"$@"
}

python_compile() {
	wrap_setup distutils-r1_python_compile --build-lib="${BUILD_DIR}"/lib
}

python_test() {
	wrap_setup distutils_install_for_testing

	virtx "${EPYTHON}" -c "import sys, matplotlib as m; sys.exit(0 if m.test(verbosity=2) else 1)"
}

python_install() {
	wrap_setup distutils-r1_python_install

	# mpl_toolkits namespace
	python_moduleinto mpl_toolkits
	python_domodule lib/mpl_toolkits/__init__.py
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
