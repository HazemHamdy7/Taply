import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';

class BusinessCardDataAdapter {
  BusinessCardDataAdapter._();

  static BusinessCardData toEngineData(BusinessCard card) {
    return BusinessCardData(
      fullName: _v(card.fullName),
      firstName: _v(card.fullName.split(' ').firstOrNull),
      lastName: _v(card.fullName.split(' ').skip(1).join(' ')),
      jobTitle: _v(card.jobTitle),
      company: _v(card.companyName),
      email: _v(card.email),
      phone: _v(card.mobileNumber),
      website: _v(card.website),
      address: _v(card.address),
      bio: _v(card.aboutMe),
      profileImage: card.profileImagePath,
      social: {
        if (card.linkedin.isNotEmpty) 'linkedin': card.linkedin,
        if (card.facebook.isNotEmpty) 'facebook': card.facebook,
        if (card.instagram.isNotEmpty) 'instagram': card.instagram,
        if (card.telegram.isNotEmpty) 'telegram': card.telegram,
        if (card.youtube.isNotEmpty) 'youtube': card.youtube,
        if (card.x.isNotEmpty) 'x': card.x,
        if (card.whatsappNumber.isNotEmpty) 'whatsapp': card.whatsappNumber,
      },
      custom: {
        if (card.mobileNumber2.isNotEmpty) 'mobileNumber2': card.mobileNumber2,
        if (card.tagline.isNotEmpty) 'tagline': card.tagline,
      },
    );
  }

  static String? _v(String? s) => (s == null || s.isEmpty) ? null : s;
}
