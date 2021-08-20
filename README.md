# gentoo-overlay

Ștefan Talpalaru's personal Gentoo Linux overlay.

## Installing

This overlay is available in the official Gentoo list. Add it with `layman -a stefantalpalaru` or `eselect repository enable stefantalpalaru`.

## Counting packages

`ls -Fd */* | grep '/$' | grep -Ev '^(profiles|metadata)' | wc -l`

