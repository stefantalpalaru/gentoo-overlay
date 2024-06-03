# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE='xml(+)'
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 git-r3

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="https://github.com/Diaoul/subliminal
	https://pypi.org/project/subliminal/"
EGIT_REPO_URI="https://github.com/Diaoul/${PN}.git"
EGIT_BRANCH="develop"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/babelfish-0.6.1[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup4-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/chardet-5.0[${PYTHON_USEDEP}]
		>=dev-python/click-8.0[${PYTHON_USEDEP}]
		>=dev-python/click-option-group-0.5.6[${PYTHON_USEDEP}]
		>=dev-python/dogpile-cache-1.0[${PYTHON_USEDEP}]
		>=dev-python/enzyme-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/guessit-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/platformdirs-4.2[${PYTHON_USEDEP}]
		>=dev-python/pysubs2-1.7[${PYTHON_USEDEP}]
		>=dev-python/rarfile-2.7[compressed,${PYTHON_USEDEP}]
		>=dev-python/rebulk-3.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/srt-3.5[${PYTHON_USEDEP}]
		>=dev-python/stevedore-3.0[${PYTHON_USEDEP}]
		>=dev-python/tomli-2[${PYTHON_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"

# Tests don't work in 2.0.5. Recheck in later versions. See Gentoo bug 630114.
RESTRICT=test
