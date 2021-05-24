# docker-godot-build

A docker image for Godot Mono builds including the tools necessary to generate production-ready distributables.

Tools included:
- Wine (64 and 32 bit)
- [Rcedit](https://github.com/electron/rcedit) to change Windows executable metadata
- [NSIS](https://nsis.sourceforge.io/Main_Page) to create Windows installers
- ImageMagick to generate .ico files
