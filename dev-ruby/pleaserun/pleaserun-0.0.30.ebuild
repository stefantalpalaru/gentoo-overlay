# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26"

inherit ruby-fakegem

DESCRIPTION="tool to generate startup scripts and service definitions"
HOMEPAGE="https://github.com/jordansissel/pleaserun"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "
	dev-ruby/cabin
	dev-ruby/clamp
	dev-ruby/stud
	~dev-ruby/mustache-0.99.8
	dev-ruby/insist
	dev-ruby/dotenv
"
