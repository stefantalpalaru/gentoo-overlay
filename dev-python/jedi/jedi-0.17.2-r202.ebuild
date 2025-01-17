# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

TYPESHED_P="typeshed-jedi_v0.16.0"
DJANGO_STUBS_P="django-stubs-v1.5.0"

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="
	https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/davidhalter/typeshed/archive/${TYPESHED_P#typeshed-}.tar.gz
		-> ${TYPESHED_P}.gh.tar.gz
	https://github.com/davidhalter/django-stubs/archive/${DJANGO_STUBS_P#django-stubs-}.tar.gz
		-> ${DJANGO_STUBS_P/v/}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
RESTRICT="test"

RDEPEND=">=dev-python/parso-0.7.0[${PYTHON_USEDEP}]
	!<dev-python/jedi-0.17.2-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

python_prepare_all() {
	# upstream includes these as submodules ...
	rmdir "${S}"/jedi/third_party/{django-stubs,typeshed} || die
	mv "${WORKDIR}/${DJANGO_STUBS_P/v/}" \
		"${S}/jedi/third_party/django-stubs" || die
	mv "${WORKDIR}/${TYPESHED_P}" \
		"${S}/jedi/third_party/typeshed" || die

	# don't run doctests, don't depend on colorama
	sed -i "s:'docopt',:: ; s:'colorama',::" setup.py || die
	sed -i "s: --doctest-modules::" pytest.ini || die

	# speed tests are fragile
	rm test/test_speed.py || die

	# test_complete_expanduser relies on $HOME not being empty
	touch "${HOME}"/somefile || die

	# TODO: investigate
	sed -e 's:test_local_import:_&:' \
		-i test/test_utils.py || die
	sed -e '/with sqlite3\.connect/,+2d' \
		-i test/completion/stdlib.py || die
	rm test/completion/django.py || die

	# tests relying on pristine virtualenv
	# this relies on test* not matching anything else
	sed -e "/#\? \['test'\]/,+1d" \
		-i test/completion/on_import.py || die
	# this one's broken by 'path' module (dev-python/path)
	sed -e 's:test_os_issues:_&:' \
		-i test/test_inference/test_imports.py || die
	sed -e 's:test_venv_and_pths:_&:' \
		-i test/test_inference/test_sys_path.py || die

	distutils-r1_python_prepare_all
}
