# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python client for the Prometheus monitoring system"
HOMEPAGE="https://pypi.org/project/prometheus_client/
	https://github.com/prometheus/client_python"
SRC_URI="https://github.com/prometheus/client_python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/client_python-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="dev-python/twisted[${PYTHON_USEDEP}]
	!<dev-python/prometheus-client-0.7.1-r200[${PYTHON_USEDEP}]
"
