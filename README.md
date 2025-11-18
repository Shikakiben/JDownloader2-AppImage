#  Unofficial JDownloader2-AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/Shikakiben/JDownloader2-AppImage/total?logo=github&label=GitHub%20Downloads)](https://github.com/Shikakiben/JDownloader2-AppImage/releases/latest)
[![CI Build Status](https://github.com//Shikakiben/JDownloader2-AppImage/actions/workflows/appimage.yml/badge.svg)](https://github.com/Shikakiben/JDownloader2-AppImage/releases/latest)

<p align="center">
  <img src="https://jdownloader.org/_media/knowledge/wiki/jdownloader.png" width="128" />
</p>

* Official site: https://jdownloader.org

* [Latest Stable Release](https://github.com/Shikakiben/JDownloader2-AppImage/releases/latest)

---



AppImage made using [sharun](https://github.com/VHSgunzo/sharun), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks.

**In this particular case, JDownloader2 requires Java to run. This AppImage includes a bundled JRE for convenience, but if your system is too old or uses musl (like Alpine Linux), you may need to install the latest OpenJDK package from your distribution's package manager for proper functionality.**

This AppImage can work **without FUSE** at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

It is possible that this appimage may fail to work with appimagelauncher, I recommend using AM:



* [AM](https://github.com/ivan-hc/AM) `am -i jdownloader2` or `appman -i jdownloader2 `



More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/)



---
