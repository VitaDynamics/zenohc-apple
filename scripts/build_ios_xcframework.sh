#!/usr/bin/env bash
set -euo pipefail

IOS_DEPLOYMENT_TARGET=13.0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)" # 仓库根
BUILD_DIR="$ROOT_DIR/build-ios"
XCFRAMEWORK_OUT="$ROOT_DIR/zenohc.xcframework"

# iOS 目标三元组
DEVICE_TRIPLE="aarch64-apple-ios"
SIM_ARM64_TRIPLE="aarch64-apple-ios-sim"
SIM_X64_TRIPLE="x86_64-apple-ios"

rustup target add "$DEVICE_TRIPLE" "$SIM_ARM64_TRIPLE" "$SIM_X64_TRIPLE"

configure_build () {
  local triple="$1" name="$2"
  cmake -S "$ROOT_DIR" -B "$BUILD_DIR/$name" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_DEPLOYMENT_TARGET="${IOS_DEPLOYMENT_TARGET}" \
    -DZENOHC_BUILD_IN_SOURCE_TREE=OFF \
    -DZENOHC_CUSTOM_TARGET="${triple}" \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
  cmake --build "$BUILD_DIR/$name" --config Release
}

configure_build "$DEVICE_TRIPLE"   "device-arm64"
configure_build "$SIM_ARM64_TRIPLE" "sim-arm64"
configure_build "$SIM_X64_TRIPLE"   "sim-x64"

# 路径：CMakeLists.txt 会把产物放到 <build>/<config>/target/<triple>/release/
LIB_DEVICE="$BUILD_DIR/device-arm64/release/target/$DEVICE_TRIPLE/release/libzenohc.a"
LIB_SIM_ARM64="$BUILD_DIR/sim-arm64/release/target/$SIM_ARM64_TRIPLE/release/libzenohc.a"
LIB_SIM_X64="$BUILD_DIR/sim-x64/release/target/$SIM_X64_TRIPLE/release/libzenohc.a"

SIM_UNIVERSAL="$BUILD_DIR/zenohc-sim-universal.a"
lipo -create -output "$SIM_UNIVERSAL" "$LIB_SIM_ARM64" "$LIB_SIM_X64"

HEADERS="$BUILD_DIR/device-arm64/release/include" # 各构建的头一致，取其一
rm -rf "$XCFRAMEWORK_OUT"
xcodebuild -create-xcframework \
  -library "$LIB_DEVICE" -headers "$HEADERS" \
  -library "$SIM_UNIVERSAL" -headers "$HEADERS" \
  -output "$XCFRAMEWORK_OUT"

echo "Done: $XCFRAMEWORK_OUT"   