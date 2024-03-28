# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
BDEPEND="
	~sci-libs/caffe2-${PV}[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="
	${PYTHON_DEPS}
	${BDEPEND}
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/opt-einsum[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}"/pytorch-2.1.0-don-t-build-libtorch-again.patch
	"${FILESDIR}"/pytorch-1.9.0-Change-library-directory-according-to-CMake-build.patch
	"${FILESDIR}"/pytorch-2.0.0-global-dlopen.patch
	"${FILESDIR}"/pytorch-1.7.1-torch_shm_manager.patch
	"${FILESDIR}"/${PN}-1.13.0-setup.patch
)

src_prepare() {
	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|${EPREFIX}/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die

	# Crazy workaround for splitting "caffe2" and "pytorch" in two different packages:
	cp -a "${EPREFIX}/usr/$(get_libdir)/functorch.so" functorch/ || die

	distutils-r1_src_prepare
}

src_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	BUILD_DIR= \
	distutils-r1_src_compile
}

src_install() {
	USE_SYSTEM_LIBS=ON distutils-r1_src_install
}
