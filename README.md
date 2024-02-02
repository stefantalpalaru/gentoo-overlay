# gentoo-overlay

Ștefan Talpalaru's personal Gentoo Linux overlay.

## Installing

This overlay is available in the official Gentoo list. Add it with:

```bash
eselect repository enable stefantalpalaru
emaint sync --repo stefantalpalaru
```

## Counting packages

`ls -Fd */* | grep '/$' | grep -Ev '^(profiles|metadata|acct-)' | wc -l`

