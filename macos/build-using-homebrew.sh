#!/bin/sh

# Authors: Boris Pek
# License: Public Domain
# Created: 2018-08-21
# Created: 2018-08-21
# Version: N/A
#
# Description: script for personal use
#
# Notes:
# brew install wget git htop coreutils
# brew install cmake gettext libidn openssl jsoncpp miniupnpc aspell pcre lua qt

set -e

[ -z "${HOMEBREW}" ] && HOMEBREW="${HOME}/Homebrew"
[ -z "${DEPLOYMENT_TARGET}" ] && DEPLOYMENT_TARGET="10.13"

MACOS_SDK="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
TOOLCHAIN_OPTIONS="-DCMAKE_PREFIX_PATH='${HOMEBREW};${HOMEBREW}/opt/qt;${HOMEBREW}/opt/openssl;${HOMEBREW}/opt/gettext;${HOMEBREW}/opt/libidn2;${MACOS_SDK}'"
BUILD_OPTIONS="-DCMAKE_BUILD_TYPE=Release -DUSE_MINIUPNP=ON -DLOCAL_MINIUPNP=OFF -DFREE_SPACE_BAR_C=ON -DWITH_SOUNDS=ON -DUSE_ASPELL=ON -DPERL_REGEX=ON -DLUA_SCRIPT=ON -DWITH_DHT=ON -DLOCAL_BOOST=OFF -DUSE_QT=OFF -DUSE_QT5=ON"
ARCH="-DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET='${DEPLOYMENT_TARGET}' -DCMAKE_OSX_SYSROOT='${MACOS_SDK}'"
COMPILER="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"

PATH="${HOMEBREW}/bin:${PATH}"
CUR_DIR="$(dirname $(realpath -s ${0}))"
MAIN_DIR="$(realpath -s ${CUR_DIR}/..)"

mkdir -p "${MAIN_DIR}/builddir"
cd "${MAIN_DIR}/builddir"

cmake .. ${TOOLCHAIN_OPTIONS} ${BUILD_OPTIONS} ${ARCH} ${COMPILER} "$@"
cmake --build . --target all --parallel 4

cpack -G DragNDrop
cp -a EiskaltDC++*.dmg "${MAIN_DIR}/../"

echo
echo "App bundle is built successfully! See:"
echo "$(realpath -s ${MAIN_DIR}/..)/$(ls EiskaltDC++*.dmg | sort -V | tail -n1)"
echo
