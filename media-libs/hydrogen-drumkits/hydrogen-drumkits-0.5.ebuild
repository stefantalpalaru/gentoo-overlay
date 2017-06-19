# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="free drumkits for hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
SRC_URI="
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ForzeeStereo.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Boss_DR-110.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/circAfrique%20v4.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/BJA_Pacific.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/DeathMetal.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Millo_MultiLayered3.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Millo_MultiLayered2.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Millo-Drums_v.1.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/HardElectro1.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ElectricEmpireKit.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Classic-626.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Classic-808.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/K-27_Trash_Kit.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/EasternHop-1.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/YamahaVintageKit.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ColomboAcousticDrumkit.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ErnysPercussion.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/TR808909.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Techno-1.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/TD-7kit.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Synthie-1.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/HipHop-2.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/HipHop-1.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/3355606kit.h2drumkit
	mirror://sourceforge/hydrogen/Sound%20Libraries/Main%20sound%20libraries/VariBreaks.h2drumkit
"
RESTRICT="mirror"

LICENSE="OpenMusic CC-BY-SA-3.0 CC-BY-4.0 GPL-2 GPL-2+ public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
RDEPEND="media-sound/hydrogen"

S="${WORKDIR}"

src_unpack(){
	cp "${DISTDIR}"/*.h2drumkit "${S}"
	for F in *.h2drumkit; do
		tar xzf "${F}"
		rm "${F}"
	done
	find -type f -name '._*' -delete
}

src_install(){
	insinto  /usr/share/hydrogen/data/drumkits/
	doins -r *
}
