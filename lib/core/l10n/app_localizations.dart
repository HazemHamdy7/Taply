import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Digital Business Card'**
  String get appTitle;

  /// No description provided for @createCard.
  ///
  /// In en, this message translates to:
  /// **'Create Business Card'**
  String get createCard;

  /// No description provided for @editCard.
  ///
  /// In en, this message translates to:
  /// **'Edit Business Card'**
  String get editCard;

  /// No description provided for @myCard.
  ///
  /// In en, this message translates to:
  /// **'My Card'**
  String get myCard;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get whatsappNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @linkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedin;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @nfc.
  ///
  /// In en, this message translates to:
  /// **'NFC'**
  String get nfc;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @saveQR.
  ///
  /// In en, this message translates to:
  /// **'Save QR'**
  String get saveQR;

  /// No description provided for @shareQR.
  ///
  /// In en, this message translates to:
  /// **'Share QR'**
  String get shareQR;

  /// No description provided for @viewQR.
  ///
  /// In en, this message translates to:
  /// **'View QR Code'**
  String get viewQR;

  /// No description provided for @writeNFC.
  ///
  /// In en, this message translates to:
  /// **'Write to NFC Tag'**
  String get writeNFC;

  /// No description provided for @readNFC.
  ///
  /// In en, this message translates to:
  /// **'Read NFC Tag'**
  String get readNFC;

  /// No description provided for @tapToWrite.
  ///
  /// In en, this message translates to:
  /// **'Tap to write to NFC tag'**
  String get tapToWrite;

  /// No description provided for @tapToRead.
  ///
  /// In en, this message translates to:
  /// **'Tap to read NFC tag'**
  String get tapToRead;

  /// No description provided for @writeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data written successfully'**
  String get writeSuccess;

  /// No description provided for @readSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data read successfully'**
  String get readSuccess;

  /// No description provided for @noCard.
  ///
  /// In en, this message translates to:
  /// **'No business card found. Create one now.'**
  String get noCard;

  /// No description provided for @cardPreview.
  ///
  /// In en, this message translates to:
  /// **'Card Preview'**
  String get cardPreview;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @profileImage.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this card?'**
  String get deleteMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @nfcWriteInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone near the NFC tag to write data'**
  String get nfcWriteInstruction;

  /// No description provided for @nfcReadInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone near the NFC tag to read data'**
  String get nfcReadInstruction;

  /// No description provided for @nfcNotSupported.
  ///
  /// In en, this message translates to:
  /// **'NFC is not supported on this device'**
  String get nfcNotSupported;

  /// No description provided for @myCards.
  ///
  /// In en, this message translates to:
  /// **'My Cards'**
  String get myCards;

  /// No description provided for @scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get scanned;

  /// No description provided for @addYourCard.
  ///
  /// In en, this message translates to:
  /// **'Add Your Card'**
  String get addYourCard;

  /// No description provided for @createDigitalCard.
  ///
  /// In en, this message translates to:
  /// **'Create a digital business card to share with anyone'**
  String get createDigitalCard;

  /// No description provided for @createYourCard.
  ///
  /// In en, this message translates to:
  /// **'Create Your Card'**
  String get createYourCard;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Tagline'**
  String get tagline;

  /// No description provided for @mobileNumber2.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number 2'**
  String get mobileNumber2;

  /// No description provided for @xTwitter.
  ///
  /// In en, this message translates to:
  /// **'X (Twitter)'**
  String get xTwitter;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @cardDeleted.
  ///
  /// In en, this message translates to:
  /// **'Card deleted'**
  String get cardDeleted;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete Card'**
  String get deleteCard;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;

  /// No description provided for @cardSaved.
  ///
  /// In en, this message translates to:
  /// **'Card saved'**
  String get cardSaved;

  /// No description provided for @cardAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'This card is already saved'**
  String get cardAlreadySaved;

  /// No description provided for @call2.
  ///
  /// In en, this message translates to:
  /// **'Call 2'**
  String get call2;

  /// No description provided for @searchScannedCards.
  ///
  /// In en, this message translates to:
  /// **'Search scanned cards...'**
  String get searchScannedCards;

  /// No description provided for @noMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No cards match your search'**
  String get noMatchSearch;

  /// No description provided for @noScannedCards.
  ///
  /// In en, this message translates to:
  /// **'No scanned cards yet'**
  String get noScannedCards;

  /// No description provided for @scanToSave.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code or NFC tag to save a card here'**
  String get scanToSave;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @noTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates available'**
  String get noTemplates;

  /// No description provided for @templateGallery.
  ///
  /// In en, this message translates to:
  /// **'Template Gallery'**
  String get templateGallery;

  /// No description provided for @qrCodeSaved.
  ///
  /// In en, this message translates to:
  /// **'QR Code saved to gallery'**
  String get qrCodeSaved;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String errorSaving(Object error);

  /// No description provided for @noCardData.
  ///
  /// In en, this message translates to:
  /// **'No card data available'**
  String get noCardData;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @nfcDisabled.
  ///
  /// In en, this message translates to:
  /// **'NFC is disabled. Please enable it in settings.'**
  String get nfcDisabled;

  /// No description provided for @placePhoneNearTag.
  ///
  /// In en, this message translates to:
  /// **'Place your phone near the tag...'**
  String get placePhoneNearTag;

  /// No description provided for @nfcActions.
  ///
  /// In en, this message translates to:
  /// **'NFC Actions'**
  String get nfcActions;

  /// No description provided for @cardTheme.
  ///
  /// In en, this message translates to:
  /// **'Card Theme'**
  String get cardTheme;

  /// No description provided for @browseAll.
  ///
  /// In en, this message translates to:
  /// **'Browse All'**
  String get browseAll;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark mode is enabled'**
  String get darkModeEnabled;

  /// No description provided for @lightModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light mode is enabled'**
  String get lightModeEnabled;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system setting'**
  String get followSystem;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English language'**
  String get englishLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'اللغة العربية'**
  String get arabicLanguage;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Digital Business Card v1.0.0'**
  String get version;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to Gallery'**
  String get saveToGallery;

  /// No description provided for @shareAsImage.
  ///
  /// In en, this message translates to:
  /// **'Share as Image'**
  String get shareAsImage;

  /// No description provided for @saveContactVcf.
  ///
  /// In en, this message translates to:
  /// **'Save Contact (VCF)'**
  String get saveContactVcf;

  /// No description provided for @addToPhoneContacts.
  ///
  /// In en, this message translates to:
  /// **'Add to Phone Contacts'**
  String get addToPhoneContacts;

  /// No description provided for @hiResExport.
  ///
  /// In en, this message translates to:
  /// **'High Res Export (1920px)'**
  String get hiResExport;

  /// No description provided for @exportCard.
  ///
  /// In en, this message translates to:
  /// **'Export Card'**
  String get exportCard;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @selectCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Select Country Code'**
  String get selectCountryCode;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @deleteCardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\" card?'**
  String deleteCardConfirm(Object name);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @renameCategory.
  ///
  /// In en, this message translates to:
  /// **'Rename Category'**
  String get renameCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\" category?'**
  String deleteCategoryConfirm(Object name);

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @assignCategories.
  ///
  /// In en, this message translates to:
  /// **'Assign Categories'**
  String get assignCategories;

  /// No description provided for @noCategoriesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No categories assigned'**
  String get noCategoriesAssigned;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available. Create one first.'**
  String get noCategoriesAvailable;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortByName;

  /// No description provided for @sortByCategory.
  ///
  /// In en, this message translates to:
  /// **'Sort by Category'**
  String get sortByCategory;

  /// No description provided for @categoryDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get categoryDefault;

  /// No description provided for @allCards.
  ///
  /// In en, this message translates to:
  /// **'All Cards'**
  String get allCards;

  /// No description provided for @favoritesOnly.
  ///
  /// In en, this message translates to:
  /// **'Favorites Only'**
  String get favoritesOnly;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @sortByFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites First'**
  String get sortByFavorites;

  /// No description provided for @noFavoriteCards.
  ///
  /// In en, this message translates to:
  /// **'No favorite cards yet'**
  String get noFavoriteCards;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @analyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'View usage statistics'**
  String get analyticsDescription;

  /// No description provided for @eventBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Event Breakdown'**
  String get eventBreakdown;

  /// No description provided for @dailyActivity.
  ///
  /// In en, this message translates to:
  /// **'Daily Activity (7 days)'**
  String get dailyActivity;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity (4 weeks)'**
  String get weeklyActivity;

  /// No description provided for @monthlyActivity.
  ///
  /// In en, this message translates to:
  /// **'Monthly Activity (6 months)'**
  String get monthlyActivity;

  /// No description provided for @totalEvents.
  ///
  /// In en, this message translates to:
  /// **'Total Events'**
  String get totalEvents;

  /// No description provided for @mostViewed.
  ///
  /// In en, this message translates to:
  /// **'Most Viewed'**
  String get mostViewed;

  /// No description provided for @mostShared.
  ///
  /// In en, this message translates to:
  /// **'Most Shared'**
  String get mostShared;

  /// No description provided for @noAnalyticsData.
  ///
  /// In en, this message translates to:
  /// **'No analytics data yet'**
  String get noAnalyticsData;

  /// No description provided for @analyticsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Analytics will appear here as you use the app'**
  String get analyticsEmptyHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
