# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 multiprocessing pypi

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="
	>=dev-python/cython-0.28.3:python2[${PYTHON_USEDEP}]
"
RDEPEND=">=dev-libs/openssl-1.0.2:0=[-bindist]
	dev-python/protobuf:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	net-dns/c-ares:=
	sys-libs/zlib:=
	!<dev-python/grpcio-1.26.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_configure_all() {
	export GRPC_PYTHON_DISABLE_LIBC_COMPATIBILITY=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}
