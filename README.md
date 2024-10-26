# gentoo-overlay

Ștefan Talpalaru's personal Gentoo Linux overlay.

## Installing

This overlay is [no longer
available](https://github.com/gentoo/api-gentoo-org/commit/7c46900a7c4cd57b11091ae8327a1e855bb97762)
in the official Gentoo list, because core Gentoo devs are as petty as they
are incompetent. Add it with:

```text
eselect repository enable guru
eselect repository add stefantalpalaru git https://github.com/stefantalpalaru/gentoo-overlay
emaint sync
```

If, at some point in the past, you added this overlay using `eselect
repository enable stefantalpalaru` you are stuck with a Gentoo-controlled
overlay mirror that stopped mirroring on July 21, 2024. You need to remove
the overlay and add it again:

```text
eselect repository remove stefantalpalaru
eselect repository add stefantalpalaru git https://github.com/stefantalpalaru/gentoo-overlay
emaint sync --repo stefantalpalaru
```

## Counting packages

`ls -Fd */* | grep '/$' | grep -Ev '^(profiles|metadata|acct-)' | wc -l`

