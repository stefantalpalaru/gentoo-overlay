# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="${PN//-/_}"

inherit distutils-r1 pypi

DESCRIPTION="Adds backup-schedule extension support to python-novaclient"
HOMEPAGE="https://github.com/rackspace/rax_backup_schedule_python_novaclient_ext"
S="${WORKDIR}/rax_scheduled_images_python_novaclient_ext-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.10.0[${PYTHON_USEDEP}]
	!<dev-python/rax-scheduled-images-python-novaclient-ext-0.3.1-r200[${PYTHON_USEDEP}]
"
