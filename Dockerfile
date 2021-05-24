# Based on barichello/godot-ci:mono and 
# https://github.com/aBARICHELLO/godot-ci
# https://github.com/abarichello/godot-ci/blob/master/LICENSE

# Image layers:
# FROM debian:buster-slim
# FROM mono:latest
FROM barichello/godot-ci:mono-3.3.1


# Add Android dependencies (based on barichello/godot-ci, see license above)
RUN echo "deb http://security.debian.org/debian-security stretch/updates main" | tee -a /etc/apt/sources.list \
    && mkdir -p /usr/share/man/man1 \
    && apt-get update -qq && apt-get install -qq adb openjdk-8-jdk-headless
RUN keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 \
    && mv debug.keystore /root/debug.keystore
RUN godot -e -q
RUN echo 'export/android/adb = "/usr/bin/adb"' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/jarsigner = "/usr/bin/jarsigner"' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/debug_keystore = "/root/debug.keystore"' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/debug_keystore_user = "androiddebugkey"' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/debug_keystore_pass = "android"' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/force_system_user = false' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/timestamping_authority_url = ""' >> ~/.config/godot/editor_settings-3.tres \
    && echo 'export/android/shutdown_adb_on_exit = true' >> ~/.config/godot/editor_settings-3.tres


# Add 64-bit wine
RUN apt-get update -qq && apt-get install -qq --no-install-recommends wine


# Add NSIS (based on cdrx/nsis)
# https://github.com/cdrx/docker-nsis
# Copyright (c) 2018, Chris R, All rights reserved.
# Lincesed under a BSD 2-Clause License:
# https://github.com/cdrx/docker-nsis/blob/master/LICENSE
RUN dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq procps wine32 wine32-development \
    && wget -q http://downloads.sourceforge.net/project/nsis/NSIS%203/3.03/nsis-3.03-setup.exe \
    && WINEARCH=win32 WINEDEBUG=-all WINEPREFIX=/root/.wine32 wine nsis-3.03-setup.exe /S \
    && while pgrep wineserver >/dev/null; do echo "Waiting for wineserver"; sleep 1; done \
    && rm -rf /tmp/.wine-* \
    && rm -f nsis-3.03-setup.exe \
    && echo 'WINEDEBUG=-all wine "/root/.wine32/drive_c/Program Files/NSIS/makensis.exe" "$@"' > /usr/bin/makensis \
    && chmod +x /usr/bin/makensis


# Add rcedit
RUN wget -q https://github.com/electron/rcedit/releases/download/v1.1.1/rcedit-x64.exe \
    && mkdir -p "/root/.wine/drive_c/Program Files/Rcedit" \
    && mv rcedit-x64.exe "/root/.wine/drive_c/Program Files/Rcedit" \
    && echo 'WINEDEBUG=-all wine "/root/.wine/drive_c/Program Files/Rcedit/rcedit-x64.exe" "$@"' > /usr/bin/rcedit \
    && chmod +x /usr/bin/rcedit


# Other dependencies
RUN apt-get install -qq imagemagick


# Cleanup 
RUN apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf Godot_v*
