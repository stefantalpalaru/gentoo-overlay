# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="high-performance CUDA Library for Direct Sparse Solvers"
HOMEPAGE="https://developer.nvidia.com/cudss"
SRC_URI="https://developer.download.nvidia.com/compute/cudss/redist/libcudss/linux-x86_64/libcudss-linux-x86_64-${PV}_cuda12-archive.tar.xz"
S="${WORKDIR}/libcudss-linux-x86_64-${PV}_cuda12-archive"
LICENSE="NVIDIA-cuDSS"
SLOT="0/0.6" # from the libcudss.so version
KEYWORDS="~amd64 ~amd64-linux"
RESTRICT="mirror"

RDEPEND="=dev-util/nvidia-cuda-toolkit-12*"

QA_PREBUILT="/opt/cuda/targets/x86_64-linux/lib/*"

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include lib
}
