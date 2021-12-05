# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

inherit ruby-fakegem

DESCRIPTION="pure Ruby RPM library"
HOMEPAGE="https://github.com/jordansissel/ruby-arr-pm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "
	dev-ruby/cabin
"
