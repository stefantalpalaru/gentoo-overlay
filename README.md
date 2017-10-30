# gentoo-overlay

Ștefan Talpalaru's personal Gentoo Linux overlay.

## Installing

This overlay is available in the official layman list. Add it with "layman -a stefantalpalaru"

Since the "rust" overlay is listed as a master, you should add it if you don't have it already
("layman -a rust") to get rid of this Portage warning:

```
Unavailable repository 'rust' referenced by masters entry in '/var/lib/layman/stefantalpalaru/metadata/layout.conf'
```

