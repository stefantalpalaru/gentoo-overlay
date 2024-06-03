# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE='xml(+)'
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="https://github.com/Diaoul/subliminal
	https://pypi.org/project/subliminal/"
SRC_URI="
	https://github.com/Diaoul/subliminal/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/appdirs-1.3[${PYTHON_USEDEP}]
		>=dev-python/babelfish-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup4-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/click-4.0[${PYTHON_USEDEP}]
		>=dev-python/dogpile-cache-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/enzyme-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/guessit-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/pysrt-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytz-2012c[${PYTHON_USEDEP}]
		>=dev-python/rarfile-2.7[compressed,${PYTHON_USEDEP}]
		>=dev-python/requests-2.0[${PYTHON_USEDEP}]
		dev-python/setuptools:0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		dev-python/soupsieve[${PYTHON_USEDEP}]
		>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"

# Tests don't work in 2.0.5. Recheck in later versions. See Gentoo bug 630114.
RESTRICT=test

python_prepare_all() {
	# Disable code checkers as they require unavailable dependencies.
	sed -i -e 's/--\(pep8\|flakes\)//g' pytest.ini || die
	sed -i -e "s/'pytest-\(pep8\|flakes\)',//g" setup.py || die

	# Disable unconditional dependency on dev-python/pytest-runner.
	sed -i -e "s|'pytest-runner'||g" setup.py || die

	distutils-r1_python_prepare_all
}
