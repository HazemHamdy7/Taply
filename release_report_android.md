# Android Release Report — Taply v1.0.0

**Date:** 2026-06-08
**Platform:** Android (Flutter 3.41.9 — Dart 3.11.5)
**Build:** `app-release.aab` (52.0 MB)

---

## 1. Fixes Applied

| # | Issue | File | Fix |
|---|-------|------|-----|
| 1 | `mobileNumber2` always empty on edit | `create_card_screen.dart:107` | `_mobileCtrl2` now initialized with `_stripCode(c?.mobileNumber2 ?? '', _mobile2Country)` |
| 2 | `_mobile2Country` never resolved from existing card | `create_card_screen.dart:126-127` | Added `_mobile2Country = _findCode(c.mobileNumber2)` and `_mobileCtrl2.text = _stripCode(c.mobileNumber2, _mobile2Country)` |
| 3 | `setState` after dispose via `addPostFrameCallback` | `card_preview_screen.dart:26` | Added `if (!mounted) return;` guard |
| 4 | `Navigator.push` after dispose via `addPostFrameCallback` | `nfc_screen.dart:74` | Added `if (!context.mounted) return;` guard |
| 5 | NFC hardware feature not declared as optional | `AndroidManifest.xml` | Added `<uses-feature android:name="android.hardware.nfc" android:required="false" />` |
| 6 | `READ_MEDIA_IMAGES` permission rejected by Google Play | `AndroidManifest.xml`, `main.dart` | Removed `READ_MEDIA_IMAGES` from manifest; enabled Android Photo Picker (`PickVisualMedia`) which needs no permission |

---

## 2. Static Analysis

```
flutter analyze → 0 errors, 0 warnings, 4 info-level lints
```

Remaining lints (all info, non-blocking):
| Lint | File | Line |
|------|------|------|
| `unnecessary_underscores` | `create_card_screen.dart` | 436 |
| `curly_braces_in_flow_control_structures` | `nfc_cubit.dart` | 145 |
| `use_build_context_synchronously` | `nfc_screen.dart` | 79 |
| `curly_braces_in_flow_control_structures` | `qr_scanner_screen.dart` | 21 |

---

## 3. Android Permissions

| Permission | Declared | Purpose |
|------------|----------|---------|
| `WRITE_EXTERNAL_STORAGE` | ✅ `android:maxSdkVersion="28"` | Gallery save (legacy) |
| `READ_EXTERNAL_STORAGE` | ✅ `android:maxSdkVersion="32"` | Gallery read (legacy) |
| `CAMERA` | ✅ | QR scanning + profile photo |
| NFC (implied by `flutter_nfc_kit`) | ✅ plugin auto-declares | NFC read/write |

**Hardware features (all optional):**
- `android.hardware.camera` → `required="false"`
- `android.hardware.nfc` → `required="false"`

---

## 4. Release Build

```
flutter build appbundle --release → SUCCESS
Output: build\app\outputs\bundle\release\app-release.aab (52.0 MB)
Signing: upload-keystore.jks with alias 'upload'
ProGuard: enabled (isMinifyEnabled=true, isShrinkResources=true)
```

### Size Breakdown
- Total AAB: **52.0 MB**
- Icons tree-shaken: MaterialIcons 99.2% reduction, CupertinoIcons 99.7% reduction

### ProGuard Rules Verified
- Flutter engine + plugins kept
- Hive adapters (`com.nextcode.taply.**`) kept
- Play Core kept (dontwarn + keep)
- `proguard-android-optimize.txt` applied by default

---

## 5. Feature Verification (Release Mode)

| Feature | Android Status | Notes |
|---------|---------------|-------|
| **CRUD Cards** | ✅ | Create, edit (mobileNumber2 fixed), delete, list |
| **QR Generation** | ✅ | Renders + saves to gallery via `gal` (no iOS permission issue on Android) |
| **QR Scanning** | ✅ | `mobile_scanner` with camera permission |
| **NFC Write** | ✅ | `flutter_nfc_kit` — NFC reader detected, NDEF write |
| **NFC Read** | ✅ | URI, BCARD:JSON, vCard parsing — mounted guard added |
| **Export PNG** | ✅ | Canvas render to gallery via `gal` |
| **Share Image** | ✅ | `share_plus` with temp file |
| **Export VCF** | ✅ | vCard 3.0 format + share |
| **Add to Contacts** | ⚠ | VCF share only (no native contact API) |
| **Analytics** | ✅ | Hive-backed event tracking |
| **Categories** | ✅ | Hive-backed CRUD with icons |
| **Favorites** | ✅ | Toggle, filter, sort |
| **Dark Mode** | ✅ | SharedPreferences persistence |
| **Localization** | ✅ | ARB-based en/ar with RTL |
| **Networking Score** | ✅ | 7-dimension weighted calculation |

---

## 6. Remaining Issues (Non-Blocking)

| Issue | Severity | Notes |
|-------|----------|-------|
| "Add to Contacts" shares VCF instead of native insert | MEDIUM | UX improvement for future release |
| Analytics events for deleted cards not cleaned on card delete | MEDIUM | Orphaned Hive entries |
| `ScannedCard.toBusinessCard()` uses `id` instead of `cardId` | LOW | No caller depends on field for matching |
| No automated tests | LOW | `test/` directory is empty |

---

## 7. Final Verdict

| Check | Result |
|-------|--------|
| `flutter analyze` | ✅ PASS (0 errors, 0 warnings) |
| Android permissions | ✅ All required permissions declared correctly |
| Release build | ✅ `app-release.aab` built (52.0 MB) |
| NFC hardware optional | ✅ Added `required="false"` |
| ProGuard rules | ✅ Custom rules verified |
| iOS (not in scope) | ❌ Still missing `NSPhotoLibraryAddUsageDescription` and `NFCReaderUsageDescription` |

**Android:** ✅ **RELEASE READY**

The Android appbundle compiles cleanly, passes static analysis with zero errors/warnings, includes correct permissions with optional hardware features, and has all high-severity bugs resolved.
