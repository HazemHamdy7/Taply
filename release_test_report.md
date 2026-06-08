# Release Test Report — Taply v1.0.0

**Date:** 2026-06-08  
**Platform:** Flutter 3.41.9 (stable) — Dart 3.11.5 (Android / iOS / Web / Desktop)  
**Methodology:** Full static code analysis of all source files + `flutter analyze`; no device-level execution was performed.

---

## Summary

| Severity     | Count | Verdict           |
| ------------ | ----- | ----------------- |
| **Critical** | 2     | ❌ BLOCKING       |
| **High**     | 1     | 🟡 Must Fix       |
| **Medium**   | 3     | 🟠 Should Fix     |
| **Low**      | 6     | 🔵 Nice to Have   |
| **Passing**  | 8     | ✅ Pass           |

**Overall: ⚠ NOT RELEASE READY** — 2 missing iOS permissions will crash at runtime. No compilation errors.

---

## 1. CREATE CARD — `create_card_screen.dart`

| Check         | Result | Notes |
| ------------- | ------ | ----- |
| Form renders  | ✅     | 17 input fields, live preview, template picker |
| Validation    | ✅     | FullName required; form key validation |
| Image picker  | ✅     | Gallery + camera via `image_picker` |
| Phone prefix  | ✅     | Country code prepended via `_prefixed()` |
| Save to Hive  | ✅     | Via `BusinessCardCubit.saveCard()` |
| Navigation    | ✅     | Redirects to `/` on save |

**⚠ Edit mode loses `mobileNumber2`** — `_mobileCtrl2` is always initialized as `''` when editing (`create_card_screen.dart:107`). `_mobile2Country` is never resolved from existing card data (unlike `_mobileCountry` and `_whatsappCountry` handled at lines 121-126). → **HIGH**

---

## 2. EDIT CARD — `create_card_screen.dart` (with `existingCard`)

| Check              | Result | Notes |
| ------------------ | ------ | ----- |
| Prefills fields    | ✅     | All 15 text controllers prefilled |
| Prefills image     | ✅     | `_profileImagePath = c?.profileImagePath` |
| Prefills template  | ✅     | `_selectedTemplateId = c?.templateId ?? 'default'` |
| Prefills phone codes | ⚠   | `_mobile2Country` not handled; see above |

---

## 3. DELETE CARD — `card_preview_screen.dart`

| Check          | Result | Notes |
| -------------- | ------ | ----- |
| Confirmation   | ✅     | `AlertDialog` with "Confirm Delete" |
| Calls cubit    | ✅     | `BusinessCardCubit.deleteCard()` |
| Handles empty  | ✅     | Pops screen or navigates if last card |
| SnackBar       | ✅     | Shows "Card deleted" |

---

## 4. QR GENERATION — `qr_screen.dart`

| Check              | Result | Notes |
| ------------------ | ------ | ----- |
| Renders QR         | ✅     | `QrImageView` from `qr_flutter` |
| Encodes card       | ✅     | `CardUrl.encode()` with gzipped JSON |
| Save to gallery    | ❌     | Uses `Gal.putImageBytes()` — **crashes on iOS without `NSPhotoLibraryAddUsageDescription`** → **CRITICAL** |
| Error handling     | ✅     | Catches exceptions, shows error SnackBar |

---

## 5. QR SCANNING — `qr_scanner_screen.dart`

| Check           | Result | Notes |
| --------------- | ------ | ----- |
| Camera scanner  | ✅     | `MobileScanner` plugin |
| Decode custom   | ✅     | `CardUrl.decode()` + vCard fallback |
| Own-card detect | ✅     | Matches by ID, then by name+phone+email |
| Analytics       | ✅     | `trackQrScan()` fired |
| Navigation      | ✅     | Pushes `CardViewScreen` |

**iOS permission:** `NSCameraUsageDescription` present in Info.plist ✅

---

## 6. NFC WRITE — `nfc_screen.dart` + `nfc_cubit.dart`

| Check         | Result | Notes |
| ------------- | ------ | ----- |
| Availability  | ✅     | Checks `NFCAvailability` (supported / disabled) |
| Write flow    | ✅     | `FlutterNfcKit.poll()` → `writeNDEFRecords()` |
| Error handling | ✅   | Catches exceptions, shows error message |
| iOS message   | ✅     | Custom `iosAlertMessage` parameters |

**iOS permission:** ❌ `NFCReaderUsageDescription` **MISSING** from `Info.plist` — required by `FlutterNfcKit`. → **CRITICAL**

---

## 7. NFC READ — `nfc_cubit.dart`

| Check          | Result | Notes |
| -------------- | ------ | ----- |
| Read flow      | ✅     | `readNDEFRecords()` → parse URI/Text/raw |
| Parse formats  | ✅     | `CardUrl` URI, `BCARD:JSON`, vCard |
| Navigation     | ✅     | Pushes `CardViewScreen` on success |
| Own-card match | ✅     | Same logic as QR scanning |

**Crash risk:** `nfc_screen.dart:73-79` — `addPostFrameCallback` without `mounted` check before `Navigator.push`. → **MEDIUM**

---

## 8. EXPORT PNG — `card_export_service.dart`

| Check         | Result | Notes |
| ------------- | ------ | ----- |
| Render engine | ✅     | Pure `Canvas` via `CardCanvasRenderer` at 1080px |
| Gallery save  | ❌     | `Gal.putImageBytes()` — same iOS permission gap as QR |
| Error handling| ✅     | Returns error string, caller shows SnackBar |

---

## 9. SHARE IMAGE — `card_export_service.dart`

| Check          | Result | Notes |
| -------------- | ------ | ----- |
| Render hi-res  | ✅     | 1080px via canvas |
| Temp file      | ✅     | Via `path_provider` + `writeAsBytes` |
| Share via OS   | ✅     | `SharePlus.instance.share()` with `XFile` |
| Cleanup        | ✅     | `hiResExport` cleans up temp files |

---

## 10. EXPORT VCF — `card_vcf_generator.dart` + `card_export_service.dart`

| Check          | Result | Notes |
| -------------- | ------ | ----- |
| VCF format     | ✅     | vCard 3.0 with FN, N, TEL, EMAIL, URL, ADR, NOTE, X-SOCIAL-LINK |
| Special chars  | ✅     | Escape handler `_esc()` |
| Share          | ✅     | Saves temp `.vcf`, shares via `share_plus` |

---

## 11. ADD TO CONTACTS — `card_export_service.dart`

| Check            | Result | Notes |
| ---------------- | ------ | ----- |
| Actual implant   | ❌     | **Same as VCF share** — just shares the `.vcf` file; user must manually open and import to contacts app. Not a true "Add to Contacts" flow. → **MEDIUM** UX gap |

---

## 12. ANALYTICS — `analytics_repository_impl.dart`

| Check           | Result | Notes |
| --------------- | ------ | ----- |
| Event tracking  | ✅     | Types: qrScan, nfcOpen, cardView, share, vcfDownload, contactSave, followUp |
| Summary compute | ✅     | Daily/weekly/monthly aggregation, top viewed/shared |
| Persistence     | ✅     | Hive `AnalyticsEventModel` with manual adapter |
| Dashboard       | ✅     | OverviewCards, EventBreakdown, ActivityChart, TopCardsSection |

| | |
|---|---|
| **Duplicate `@override`** | `analytics_repository_impl.dart:154` — two `@override` annotations in a row. Not a compile error but sloppy. → **LOW** |
| **Stale events** | Events for deleted card IDs remain in Hive (only cleared when a `ScannedCard` is deleted). → **MEDIUM** |

---

## 13. CATEGORIES — `category_repository_impl.dart` + `category_cubit.dart`

| Check          | Result | Notes |
| -------------- | ------ | ----- |
| Default init   | ✅     | 6 defaults with icons, colors, localized names |
| CRUD           | ✅     | Create, rename, update, delete, reorder |
| Hive storage   | ✅     | `CategoryModel` via Hive |
| Category stats | ✅     | Dashboard with per-category breakdown |

---

## 14. FAVORITES — `scanned_card_cubit.dart` + `scanned_cards_screen.dart`

| Check           | Result | Notes |
| --------------- | ------ | ----- |
| Toggle          | ✅     | `toggleFavorite()` persists to Hive |
| Filter          | ✅     | `showFavoritesOnly` toggle chips |
| Sort            | ✅     | Favorites-first sort mode |
| Display         | ✅     | Heart icon overlay on scanned card tiles |

---

## 15. LOCALIZATION (Arabic / English) — `l10n/`

| Check        | Result | Notes |
| ------------ | ------ | ----- |
| ARB files    | ✅     | `app_en.arb` (198 strings) + `app_ar.arb` (194 strings) |
| RTL support  | ✅     | `Directionality` wraps `MaterialApp.router` based on language code |
| Dynamic text | ✅     | `Intl.message` / `AppLocalizations.of(context)` |
| Missing keys | ✅     | Arabic ARB covers all English keys |

---

## 16. DARK MODE — `settings_cubit.dart` + `app_theme.dart`

| Check         | Result | Notes |
| ------------- | ------ | ----- |
| Light theme   | ✅     | Material 3, blue seed color |
| Dark theme    | ✅     | Mirror structure with `Brightness.dark` |
| Persistence   | ✅     | `SharedPreferences` (key: `theme_mode`) |
| Toggle        | ✅     | Settings screen `SwitchListTile` |

---

## 17. NETWORKING SCORE — `networking_score_service.dart`

| Check         | Result | Notes |
| ------------- | ------ | ----- |
| Score calc    | ✅     | 7 weighted dimensions, max 100, clamped |
| Insights      | ✅     | Contextual tips based on score gaps (max 3) |
| Tiers         | ✅     | Beginner / Active / Professional / Expert |
| Integration   | ✅     | Cubit sources analytics + scanned cards |

---

## 18. SETTINGS SCREEN — `settings_screen.dart`

| Check           | Result | Notes |
| --------------- | ------ | ----- |
| Theme toggle    | ✅     | `SwitchListTile` with system follow label |
| Language radio  | ✅     | `RadioGroup<String>` (line 63) — valid Flutter 3.41.9 widget from `package:flutter/src/widgets/radio_group.dart`. Compiles and runs correctly. |
| Analytics link  | ✅     | Navigates to `/analytics` |
| Version display | ✅     | Shows "Taply v1.0.0" |

---

## 19. ADDITIONAL ISSUES

| Issue | File | Severity |
| ----- | ---- | -------- |
| Missing `NSPhotoLibraryAddUsageDescription` (iOS) for `gal` gallery saves | `Info.plist` | **CRITICAL** |
| Missing `NFCReaderUsageDescription` (iOS) for `FlutterNfcKit` | `Info.plist` | **CRITICAL** |
| `mobileNumber2` lost on edit | `create_card_screen.dart:107` | **HIGH** |
| `addPostFrameCallback` without `mounted` check | `nfc_screen.dart:73`, `analytics_dashboard.dart:27`, `scanned_cards.dart:29`, `card_preview.dart:25` | **MEDIUM** |
| "Add to Contacts" just shares VCF (no native contact insert) | `card_export_service.dart:65-70` | **MEDIUM** |
| Analytics events for deleted cards not cleaned on card delete | `analytics_repository_impl.dart` | **MEDIUM** |
| `ScannedCard.toBusinessCard()` uses local `id` instead of `cardId` — no caller depends on it currently | `scanned_card.dart:56-78` | **LOW** |
| ProGuard rules may strip Hive adapters | `proguard-rules.pro` | **LOW** |
| QR save-to-gallery doesn't track analytics event | `qr_screen.dart:36` | **LOW** |
| Duplicate `@override` annotation | `analytics_repository_impl.dart:154` | **LOW** |
| `_mobile2Country` not populated when editing existing card | `create_card_screen.dart:121-126` | **LOW** |
| No tests exist | `test/` (empty) | **LOW** |

---

## 20. PASSING CHECKS

| Check | Status |
| ----- | ------ |
| App launches with `runApp()` -> `MaterialApp.router` | ✅ |
| Hive initialization (5 boxes) | ✅ |
| GoRouter defines all 10 routes | ✅ |
| Dependency injection (GetIt) wiring | ✅ |
| ProGuard keeps Flutter engine + Hive adapters | ✅ |
| Android camera permission declared | ✅ |
| Android NFC hardware feature (optional) | ✅ |
| Android WRITE_EXTERNAL_STORAGE (max SDK 28) | ✅ |

---

## Final Verdict

| Area | Verdict |
| ---- | ------- |
| **Compilation** | ✅ PASS — `flutter analyze` reports 0 errors, 0 warnings, 4 info-level lints |
| **iOS Runtime** | ❌ BLOCKED — 2 missing Info.plist permissions |
| **Functional**  | 🟡 1 HIGH bug (edit loses mobileNumber2) |
| **Release Ready** | **NO** |

### Required Before Release

1. Add `NSPhotoLibraryAddUsageDescription` to `ios/Runner/Info.plist`.
2. Add `NFCReaderUsageDescription` to `ios/Runner/Info.plist`.
3. Fix `_mobileCtrl2` / `_mobile2Country` population in `create_card_screen.dart` edit mode.
4. Add `mounted` checks before `Navigator.push` in `addPostFrameCallback` handlers.
5. Consider replacing "Add to Contacts" (VCF share) with native `contact_service` plugin or deep link.
