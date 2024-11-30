# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/
		https://github.com/protocolbuffers/protobuf"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P}/python"
LICENSE="BSD"
SLOT="python2/24"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}"
RDEPEND="${BDEPEND}
	!<dev-libs/protobuf-3[python(-)]
	!<dev-python/protobuf-3.13.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	pushd "${WORKDIR}/${P}" > /dev/null || die
	eapply "${FILESDIR}/protobuf-python-3.13.0-google.protobuf.pyext._message.PyUnknownFieldRef.patch"
	eapply_user
	popd > /dev/null || die

	distutils-r1_python_prepare_all

	sed -e "/^[[:space:]]*setup_requires = \['wheel'\],$/d" -i setup.py || die
}

python_configure_all() {
	DISTUTILS_ARGS=(--cpp_implementation)
}

python_compile() {
	local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name "*.pth" -type f -delete || die
}
