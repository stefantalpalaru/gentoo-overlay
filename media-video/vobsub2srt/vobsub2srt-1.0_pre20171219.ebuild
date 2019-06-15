# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic git-r3

IUSE=""

DESCRIPTION="Converts VobSub subtitles (.sub/.idx) to .srt text subtitles using tesseract"
HOMEPAGE="https://github.com/ruediger/VobSub2SRT"
EGIT_REPO_URI="https://github.com/ruediger/VobSub2SRT"
EGIT_COMMIT="0ba6e25e078a040195d7295e860cc9064bef7c2c"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-text/tesseract"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	rm CMakeModules/FindLibavutil.cmake
	sed -i -e '/^have /d' doc/completion.sh
	sed -i -e '/DOC_DIR/d' \
		-e 's/CMAKE_C_FLAGS "/CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /' \
		-e 's/CMAKE_CXX_FLAGS "/CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11 /' \
		-e 's/-ansi //' \
		CMakeLists.txt
	sed -i -e '/directories(\${Libavutil/d' \
		-e 's/\${Libavutil_LIBRARIES}//g' \
		src/CMakeLists.txt
	sed -i -e '/find_library(Tiff_LIBRARY/,+3d' \
		CMakeModules/FindTesseract.cmake
}

src_configure() {
	append-cflags -ffast-math
	append-cxxflags -ffast-math
	cmake-utils_src_configure
}
