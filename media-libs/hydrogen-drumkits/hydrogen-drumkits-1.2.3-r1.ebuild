# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="free drumkits for hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
SRC_URI="
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/AVLDrumkits-RedZeppelin-2023.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/AVLDrumkits-BuskmansHoliday.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/AVLDrumkits-BlondeBop-HotRod.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/AVLDrumkits-BlondeBop.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/AVLDrumkits-BlackPearl-2023.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Ian%20Paice.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Tre%20Cool.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Travis%20Barker.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/John%20Bonham.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Dave%20Grohl.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/BeatBuddy_Kit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/The%20Black%20Pearl%201.0.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Lightning1024.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Gimme%20A%20Hand%201.0.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/SF3007-2011-Set-03.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ForzeeStereo.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Boss_DR-110.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/circAfrique%20v4.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/BJA_Pacific.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/DeathMetal.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Millo_MultiLayered3.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Millo_MultiLayered2.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Millo-Drums_v.1.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/HardElectro1.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ElectricEmpireKit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Classic-626.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Classic-808.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/K-27_Trash_Kit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/EasternHop-1.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/YamahaVintageKit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ColomboAcousticDrumkit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/ErnysPercussion.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/TR808909.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Techno-1.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/TD-7kit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/Synthie-1.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/HipHop-2.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/HipHop-1.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/3355606kit.h2drumkit
	https://downloads.sourceforge.net/hydrogen/Sound%20Libraries/Main%20sound%20libraries/VariBreaks.h2drumkit
"
S="${WORKDIR}"

LICENSE="OpenMusic CC-BY-SA-3.0 CC-BY-4.0 GPL-2 GPL-2+ public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

RESTRICT="mirror"
RDEPEND="media-sound/hydrogen"

src_unpack(){
	cp "${DISTDIR}"/*.h2drumkit "${S}"
	for F in *.h2drumkit; do
		tar -xzf "${F}" 2>/dev/null || tar -xf "${F}"
		rm "${F}"
	done
	find -type f -name '._*' -delete
}

src_install(){
	insinto  /usr/share/hydrogen/data/drumkits/
	doins -r *
}
