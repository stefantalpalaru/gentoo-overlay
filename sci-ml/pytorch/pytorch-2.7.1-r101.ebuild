# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
inherit distutils-r1 prefix

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
RDEPEND="
	${PYTHON_DEPS}
	~sci-ml/caffe2-${PV}[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
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
	"${FILESDIR}"/pytorch-2.6.0-dontbuildagain.patch
	"${FILESDIR}"/pytorch-2.6.0-Change-library-directory-according-to-CMake-build.patch
	"${FILESDIR}"/pytorch-2.6.0-global-dlopen.patch
	"${FILESDIR}"/pytorch-2.5.0-torch_shm_manager.patch
	"${FILESDIR}"/pytorch-2.6.0-setup.patch
	"${FILESDIR}"/pytorch-2.7.1-cpp-extension-libcxx.patch
	"${FILESDIR}"/pytorch-2.7.1-cpp-extension-multilib.patch
)

src_prepare() {
	# Replace placeholders added by cpp-extension.patch
	sed -e "s|%LIB_DIR%|$(get_libdir)|g" \
		-i torch/utils/cpp_extension.py || die

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die

	# Drop legacy from pyproject.toml
	sed -i \
		-e "/build-backend/s|:__legacy__||" \
		pyproject.toml \
		|| die

	distutils-r1_src_prepare

	# Get object file from caffe2
	cp -a "${ESYSROOT}"/var/lib/caffe2/functorch.so functorch/ || die

	hprefixify tools/setup_helpers/env.py
}

python_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	distutils-r1_python_compile
}

python_install() {
	USE_SYSTEM_LIBS=ON distutils-r1_python_install
}
