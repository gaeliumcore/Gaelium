
Debian
====================
This directory contains files used to package gaeliumd/gaelium-qt
for Debian-based Linux systems. If you compile gaeliumd/gaelium-qt yourself, there are some useful files here.

## gaelium: URI support ##


gaelium-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install gaelium-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your gaelium-qt binary to `/usr/bin`
and the `../../share/pixmaps/gaelium128.png` to `/usr/share/pixmaps`

gaelium-qt.protocol (KDE)

