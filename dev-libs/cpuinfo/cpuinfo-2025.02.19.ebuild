# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake-multilib

CommitId="b73ae6ce38d5dd0b7fe46dbe0a4b5f4bab91c7ea"

DESCRIPTION="CPU INFOrmation library"
HOMEPAGE="https://github.com/pytorch/cpuinfo/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="mirror !test? ( test )"

PATCHES=(
	"${FILESDIR}"/cpuinfo-2023.11.04-gentoo.patch
	"${FILESDIR}"/cpuinfo-2023.01.13-test.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCPUINFO_BUILD_BENCHMARKS=OFF
		-DCPUINFO_BUILD_UNIT_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
