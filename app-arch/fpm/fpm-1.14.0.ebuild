# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26"

RUBY_FAKEGEM_EXTRAINSTALL="templates"

inherit ruby-fakegem

DESCRIPTION="easily create packages for Linux distros, FreeBSD, macOS"
HOMEPAGE="https://fpm.readthedocs.io/en/latest/
		https://github.com/jordansissel/fpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "
	>=dev-ruby/json-1.7.7
	<dev-ruby/json-3
	>=dev-ruby/cabin-0.6.0
	>=dev-ruby/backports-2.6.2
	>=dev-ruby/arr-pm-0.0.11
	<dev-ruby/arr-pm-0.1
	>=dev-ruby/clamp-1.0.0
	<dev-ruby/clamp-1.1
	>=dev-ruby/pleaserun-0.0.29
	<dev-ruby/pleaserun-0.1
	>=dev-ruby/git-1.3.0
	<dev-ruby/git-2.0
	dev-ruby/stud
	dev-ruby/rexml
"
