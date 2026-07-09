# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{11..15} )
inherit distutils-r1

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
RDEPEND="
	${PYTHON_DEPS}
	~sci-ml/caffe2-${PV}[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
