# LinkBridge Linux UI starter

A first desktop UI scaffold with navy backgrounds, gray text and purple accents. It contains Overview, Devices, Send files, Clipboard, Transfers and Settings pages. No third-party dependencies are required.

## Install into the existing project
From your LinkBridge project root, first back up the current file:

```bash
cp lib/main.dart lib/main.dart.backup
```

Copy the included `lib/main.dart` over your project's `lib/main.dart`, then run:

```bash
flutter analyze
flutter run -d linux
```

Most controls are UI demos. Clipboard text can be copied to the local system clipboard, but device discovery, pairing, actual file transfer, native file picker integration, persistent preferences and cross-device clipboard synchronization are not implemented yet.
