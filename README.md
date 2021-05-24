# docker-godot-build

A docker image for Godot Mono builds including the tools necessary to generate production-ready distributables.

### Tools included:
- Wine (64 and 32 bit)
- [Rcedit](https://github.com/electron/rcedit) to change Windows executable metadata
- [NSIS](https://nsis.sourceforge.io/Main_Page) to create Windows installers
- ImageMagick to generate .ico files

### Acknowledgements:
- Uses [godot-ci from Barichello](https://github.com/aBARICHELLO/godot-ci) (MIT, [see license](https://github.com/abarichello/godot-ci/blob/master/LICENSE))
- NSIS included based on [docker-nsis from Chris R.](https://github.com/cdrx/docker-nsis) (BSD 2-Clause "Simplified", [see license](https://github.com/cdrx/docker-nsis/blob/master/LICENSE))
