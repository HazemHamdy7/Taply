# iOS Compatibility Audit — Taply v1.0.0

**Date:** 2026-06-08
**Flutter:** 3.41.9 — Dart 3.11.5
**iOS target:** 13.0 (`IPHONEOS_DEPLOYMENT_TARGET`)
**Apple device:** Requires iPhone (`LSRequiresIPhoneOS` = `true`)
**Host platform:** Windows (cannot run `flutter build ios` or `pod install`)

---

## Required Info.plist Entries

| Key | Status | Required By | Purpose |
|-----|--------|-------------|---------|
| `NSCameraUsageDescription` | ✅ Present | `mobile_scanner`, `image_picker` | QR scanning, profile photo |
| `NFCReaderUsageDescription` | ❌ **MISSING** | `flutter_nfc_kit` | NFC read/write (iOS 13+) |
| `NSPhotoLibraryAddUsageDescription` | ❌ **MISSING** | `gal` | Save QR/PNG to photo library |
| `NSPhotoLibraryUsageDescription` | ❌ **MISSING** | `image_picker`, `gal` | Pick profile photo from gallery |

**Impact:** Missing → app crashes at runtime when the relevant feature is used. App Store review will reject.

---

## Required Entitlements

| Entitlement | Status | Required By | Notes |
|-------------|--------|-------------|-------|
| **Near Field Communication Tag Reader Session** | ❌ **MISSING** | `flutter_nfc_kit` | Must enable in Apple Developer Portal + Xcode Capabilities. Without it, `FlutterNfcKit.poll()` silently returns `.not_supported` even on NFC-capable iPhones. |

**.entitlements file:** None exists. Must add `Runner.entitlements` to the Xcode project and link it in `buildSettings` → `CODE_SIGN_ENTITLEMENTS`.

---

## Plugin Compatibility Analysis

### 1. flutter_nfc_kit ^3.6.2

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ 13.0 | Matches deployment target |
| CoreNFC.framework | ✅ Weakly linked (`s.weak_frameworks`) | No crash on non-NFC devices |
| Info.plist | ❌ `NFCReaderUsageDescription` missing | **CRITICAL** |
| Entitlement | ❌ NFC Tag Reader Session missing | **CRITICAL** |
| Known bug (iOS 14.5–) | ⚠️ `poll()` with `readIso18092`/`readIso15693` requires `com.apple.developer.nfc.readersession.iso7816.select-identifiers` | Only triggers if using those tag types; basic NDEF read/write unaffected |

### 2. mobile_scanner ^7.2.0

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ 12.0 | 13.0 deployment target covers it |
| Info.plist | ✅ `NSCameraUsageDescription` present | |
| Framework | ✅ AVFoundation + Vision API (iOS native) | No entitlements needed |
| Apple Silicon | ✅ Uses sharedDarwinSource (Swift Package Manager compatible) | |

### 3. image_picker ^1.2.2

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ 13.0 | Matches |
| Info.plist (camera) | ✅ `NSCameraUsageDescription` present | |
| Info.plist (gallery) | ❌ `NSPhotoLibraryUsageDescription` missing | Crashes on pick-from-gallery on iOS 14+ |
| HEIC issue | ⚠️ Can't pick HEIC images on iOS simulators 14+ | Simulator-only, real devices fine |

### 4. share_plus ^13.1.0

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ 13.0 | Matches |
| Info.plist | ✅ None required | |
| iPad `sharePositionOrigin` | ❌ **MISSING in all 6 calls** | **CRITICAL** — crashes on iPad with `UIActivityViewController` popover. Affected: `card_export_service.dart:44,89,111` and `qr_cubit.dart:67,80`. Mitigated only by `LSRequiresIPhoneOS=true` (iPhone-only). |

### 5. gal ^2.3.2

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ 11.0 | 13.0 covers it |
| Info.plist | ❌ `NSPhotoLibraryAddUsageDescription` missing | **CRITICAL** — `Gal.putImageBytes()` crashes on iOS without this key |
| Error handling | ✅ Uses `PHPhotoLibrary` API | |

### 6. url_launcher ^6.3.2

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ 12.0 | 13.0 covers it |
| Info.plist | ✅ No custom schemes needed (uses `tel:`, `mailto:`, `https:`) | Standard iOS URL schemes don't need `LSApplicationQueriesSchemes` |

### 7. screenshot ^3.0.0

| Check | Result | Notes |
|-------|--------|-------|
| Min iOS version | ✅ Pure Dart widget | No native iOS code |
| Platform views | ⚠️ Blank for Google Maps / Camera views | Not used in this app |

---

## Podfile Status

| Check | Result |
|-------|--------|
| File exists (`ios/Podfile`) | ❌ **NOT FOUND** |
| `Generated.xcconfig` | ✅ Exists with CocoaPods config |
| Ephemeral directory | ✅ Exists with Flutter helper scripts |
| `Runner.xcworkspace` | ✅ Exists (references only `Runner.xcodeproj`, no Pods project) |

**Action required on macOS:**
```bash
flutter pub get
cd ios
pod install --repo-update
```
This generates `ios/Podfile`, downloads all native dependencies (CoreNFC, AVFoundation wrappers, etc.), and creates the `Pods/` project inside the workspace.

---

## Minimum iOS Deployment Target

| Setting | Current | Requires | Verdict |
|---------|---------|----------|---------|
| `IPHONEOS_DEPLOYMENT_TARGET` | **13.0** | 13.0 (highest plugin: flutter_nfc_kit, image_picker, share_plus) | ✅ Exact match |
| iPhone-only (`LSRequiresIPhoneOS`) | `true` | — | ⚠️ Limits App Store distribution; consider removing for iPad support |

---

## iPad Crash Risk (share_plus)

All 6 `SharePlus.instance.share()` calls lack `sharePositionOrigin`. Share_plus 13.1.0 supports this via `ShareParams(sharePositionOrigin: Rect.fromLTWH(...))`.

| File | Lines | Impact |
|------|-------|--------|
| `card_export_service.dart` | 44, 89, 111 | Share image, hi-res export, VCF share |
| `qr_cubit.dart` | 67, 80 | Share QR image |

**Mitigation:** `LSRequiresIPhoneOS = true` currently prevents iPad-native execution. Remove this key + add `sharePositionOrigin` for future iPad support.

---

## iOS Release Readiness Score

| Domain | Score | Notes |
|--------|-------|-------|
| **Info.plist completeness** | 25% | 3 of 4 required keys present (only `NSCameraUsageDescription` ✅) |
| **Entitlements** | 0% | No `.entitlements` file, no NFC entitlement |
| **Plugin compatibility** | 85% | All plugins compatible with iOS 13.0; `share_plus` iPad crash latent |
| **Min iOS version** | 100% | 13.0 matches all plugin requirements |
| **Podfile / Build setup** | 0% | Podfile does not exist; iOS build never run |
| **Static analysis** | 100% | `flutter analyze` — 0 errors, 0 warnings, 4 info lints |

**Overall Readiness Score: 52%**

---

## Critical Issues (Must Fix Before iOS Release)

| # | Issue | File | Fix |
|---|-------|------|-----|
| C1 | `NFCReaderUsageDescription` missing | `ios/Runner/Info.plist` | Add `<key>NFCReaderUsageDescription</key><string>Used to read and write NFC business card tags</string>` |
| C2 | `NSPhotoLibraryAddUsageDescription` missing | `ios/Runner/Info.plist` | Add `<key>NSPhotoLibraryAddUsageDescription</key><string>Used to save card QR codes and PNG exports to your photo library</string>` |
| C3 | `NSPhotoLibraryUsageDescription` missing | `ios/Runner/Info.plist` | Add `<key>NSPhotoLibraryUsageDescription</key><string>Used to select a profile photo from your gallery</string>` |
| C4 | NFC entitlement not configured | `ios/Runner/Runner.entitlements` | Create `.entitlements` file with `com.apple.developer.nfc.readersession.formats` = `TAG` array |
| C5 | Podfile does not exist | `ios/Podfile` | Run `flutter pub get && cd ios && pod install` on macOS |
| C6 | `sharePositionOrigin` missing on all `share_plus` calls | `card_export_service.dart` (3x), `qr_cubit.dart` (2x) | Add `sharePositionOrigin: Rect.fromLTWH(x, y, w, h)` to each `ShareParams()` |

---

## Required Before iOS Release

1. Add all 3 missing Info.plist keys (C1, C2, C3)
2. Create `Runner.entitlements` with NFC tag reading capability (C4)
3. Run `flutter pub get && cd ios && pod install` on macOS (C5)
4. Add `sharePositionOrigin` to all `SharePlus.instance.share()` calls (C6)
5. Verify build: `flutter build ios --release --no-codesign` (macOS)
6. Run `flutter analyze` to confirm 0 errors

---

## Final Verdict

| Check | Verdict |
|-------|---------|
| **Info.plist** | ❌ FAIL — 3 missing keys |
| **Entitlements** | ❌ FAIL — NFC entitlement missing |
| **Podfile / CocoaPods** | ❌ FAIL — Podfile not generated |
| **Plugin iOS version** | ✅ PASS — all compatible with iOS 13.0 |
| **Static analysis** | ✅ PASS — 0 errors |
| **iPad safety** | ❌ FAIL — `sharePositionOrigin` missing |

> ## 🛑 NO GO — iOS release blocked
>
> **6 critical issues must be resolved** before submitting to App Store. The most impactful blockers are the 3 missing Info.plist permissions (guaranteed App Store rejection + runtime crashes) and the missing Podfile (build cannot complete).
>
> Estimated effort to fix all 6 critical issues: **2–4 hours** (plist edits, entitlement setup, 6 share calls, macOS pod install + build verification).
