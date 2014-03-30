gentoo-overlay
==============

Stefan Talpalaru's overlay for Gentoo Linux packages.

##Installing

This overlay is not available in the official layman list.
To use this repository you can either add it using layman or add it manually to your layman configuration.

Add it using layman:

    layman -f -o http://stefantalpalaru.github.io/gentoo-overlay/repositories.xml -a stefantalpalaru

Add it manually:

    Edit /etc/layman/layman.cfg and include the following line for "overlays".

    http://stefantalpalaru.github.io/gentoo-overlay/repositories.xml

Should look something similar to the lines below if you don't use any other layman overlays.

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                http://stefantalpalaru.github.io/gentoo-overlay/repositories.xml
