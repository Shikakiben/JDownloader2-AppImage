#  Unofficial JDownloader 2 - AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/Shikakiben/JDownloader2-AppImage/total?logo=github&label=GitHub%20Downloads)](https://github.com/Shikakiben/JDownloader2-AppImage/releases/latest)
[![CI Build Status](https://github.com//Shikakiben/JDownloader2-AppImage/actions/workflows/appimage.yml/badge.svg)](https://github.com/Shikakiben/JDownloader2-AppImage/releases/latest)

<p align="center">
  <img src="https://jdownloader.org/_media/knowledge/wiki/jdownloader.png" width="128" />
</p>

* Official site: https://jdownloader.org

* [Latest Stable Release](https://github.com/Shikakiben/JDownloader2-AppImage/releases/latest)

---



AppImage made using [quick-sharun](https://github.com/pkgforge-dev/Anylinux-AppImages/blob/main/useful-tools/quick-sharun.sh), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks.

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.**

This AppImage can work **without FUSE** at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

This AppImage is also supplied with a self-updater by default, so any updates to this application won't be missed, you will be prompted for permission to check for updates and if agreed you will then be notified when a new update is available.

The self-updater is disabled by default when AppImage managers like [am](https://github.com/ivan-hc/AM), [soar](https://github.com/pkgforge/soar) or [dbin](https://github.com/xplshn/dbin) are present, since those manage AppImage updates.

I recommend using AM:

* [AM](https://github.com/ivan-hc/AM) `am -i jdownloader2` or `appman -i jdownloader2 `

or:

* [AM-GUI](https://github.com/Shikakiben/AM-GUI)  simply search "jdownloader2" and install it

More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/)


<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
  </a>
</details>

---
Thanks to [Samueru-sama](https://github.com/Samueru-sama) and [fiftydinar](https://github.com/fiftydinar) for making AppImage builds quicker and easier with this [TEMPLATE](https://github.com/pkgforge-dev/TEMPLATE-AppImage) using the [Anylinux-AppImages](https://github.com/pkgforge-dev/Anylinux-AppImages) tools.
