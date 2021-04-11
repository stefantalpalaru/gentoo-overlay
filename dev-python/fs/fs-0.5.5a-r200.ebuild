# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="
	https://pypi.org/project/fs/
	https://docs.pyfilesystem.org
	https://www.willmcgugan.com/tag/fs/"
MY_PV="${PV}1"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/dexml[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/fs-0.5.5a-r1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

# Tries to access FUSE
RESTRICT=test

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed -i \
		-e "s/'{0} = fs.commands.{0}:run'.format(command)/'{0} = fs.commands.{1}:run'.format(command + \"_py2\", command)/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}

pkg_postinst() {
	optfeature "S3 support" dev-python/boto
	optfeature "SFTP support" dev-python/paramiko
	optfeature "Browser support" dev-python/wxpython
}
