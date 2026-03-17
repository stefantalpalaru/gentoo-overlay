# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="084b3e3b835bb13c42c0658f033826ffa8e0f373"

PYTHON_COMPAT=( python3_{10..13} )
DOCS_BUILDER="sphinx"
DOCS_DEPEND="dev-python/sphinx-rtd-theme"
DOCS_DIR="docs/source"
inherit cmake-multilib cuda flag-o-matic python-any-r1 docs

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="http://ceres-solver.org/"
SRC_URI="https://github.com/ceres-solver/ceres-solver/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="sparse? ( BSD ) !sparse? ( LGPL-2.1 )"
SLOT="0/1"
KEYWORDS="amd64 ~x86"
IUSE="examples cuda lapack +schur sparse test"

REQUIRED_USE="sparse? ( lapack ) abi_x86_32? ( !sparse !lapack )"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	>=dev-cpp/eigen-3.3.4
	lapack? ( virtual/pkgconfig )
	doc? ( <dev-libs/mathjax-3 )
"
RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	lapack? ( virtual/lapack )
	sparse? (
		sci-libs/amd
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod[metis(+)]
		sci-libs/colamd
		sci-libs/spqr
	)
	test? (
		dev-cpp/abseil-cpp
		dev-cpp/gtest
	)
"
DEPEND="${RDEPEND}"

DOCS=( README.md VERSION )

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-system-mathjax.patch"
)

src_unpack() {
	default

	# For tests.
	ln -s "${S}/data" data
}

src_prepare() {
	cmake_src_prepare

	filter-lto

	# search paths work for prefix
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i cmake/*.cmake || die

	# remove Werror
	sed -e 's/-Werror=(all|extra)//g' \
		-i CMakeLists.txt || die

	echo "${PV}" > VERSION
}

src_configure() {
	# CUSTOM_BLAS=OFF EIGENSPARSE=OFF MINIGLOG=OFF
	local mycmakeargs=(
		-DBUILD_BENCHMARKS=OFF
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DLAPACK=$(usex lapack)
		-DSCHUR_SPECIALIZATIONS=$(usex schur)
		-DSUITESPARSE=$(usex sparse)
		-DEigen3_DIR=/usr/$(get_libdir)/cmake/eigen3

		-DBUILD_SHARED_LIBS="yes"
		-DEIGENMETIS="yes"
		-DEIGENSPARSE="yes"
		-DCUSTOM_BLAS="yes"
		-DUSE_CUDA="$(usex cuda)"
	)

	if use cuda; then
		: "${CUDAHOSTCXX:=$(cuda_gccdir)}"
		: "${CUDAARCHS:=all}"
		export CUDAHOSTCXX
		export CUDAARCHS
	fi

	use sparse || mycmakeargs+=( -DEIGENSPARSE=ON )

	cmake-multilib_src_configure
}

src_test() {
	use cuda && cuda_add_sandbox -w
	cmake-multilib_src_test
}

src_install() {
	cmake-multilib_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples data
	fi
}
