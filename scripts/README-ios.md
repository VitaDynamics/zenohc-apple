# iOS (staticlib + XCFramework)

This repository can produce an iOS static library (`libzenohc.a`) and package it as an `XCFramework`.

## One-shot build

From the repo root:

```bash
./scripts/build_ios_xcframework.sh
```

Outputs:

- `dist/ios/libzenohc-iphoneos.a`
- `dist/ios/libzenohc-iphonesimulator.a`
- `dist/zenohc.xcframework`

## Options

- Build an Intel + Apple Silicon simulator fat lib:

```bash
./scripts/build_ios_xcframework.sh --with-x86_64-sim
```

- Enable/disable cargo features:

```bash
./scripts/build_ios_xcframework.sh --features unstable
./scripts/build_ios_xcframework.sh --no-default-features --features transport_tcp
```

## Using in Xcode

Drag `dist/zenohc.xcframework` into your project and set:

- "Frameworks, Libraries, and Embedded Content": add the xcframework
- "Link Binary With Libraries": ensure it is linked

The public headers are embedded in the XCFramework, so Swift / ObjC can import the module via a bridging header or module map.
