import 'dart:convert';
import 'dart:io';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';

abstract final class CardUrl {
  static const String baseUrl = 'https://bizcard.app/c';

  static String encode(BusinessCard card) {
    final map = <String, String>{
      'id': card.id ?? '',
      'fullName': card.fullName,
      'jobTitle': card.jobTitle,
      'companyName': card.companyName,
      'tagline': card.tagline,
      'mobileNumber': card.mobileNumber,
      'mobileNumber2': card.mobileNumber2,
      'whatsappNumber': card.whatsappNumber,
      'email': card.email,
      'website': card.website,
      'linkedin': card.linkedin,
      'facebook': card.facebook,
      'instagram': card.instagram,
      'telegram': card.telegram,
      'youtube': card.youtube,
      'x': card.x,
      'address': card.address,
      'aboutMe': card.aboutMe,
      'templateId': card.templateId,
    };
    final json = jsonEncode(map);
    final compressed = GZipCodec().encode(utf8.encode(json));
    final data = base64UrlEncode(compressed);
    return '$baseUrl/${card.id ?? ''}?d=$data';
  }

  static ({BusinessCard card, String cardId})? decode(String url) {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.path.startsWith('/c/')) return null;

      final cardId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
      final dataParam = uri.queryParameters['d'];
      if (dataParam == null) return null;

      final compressed = base64Url.decode(dataParam);
      final json = utf8.decode(GZipCodec().decode(compressed));
      final map = Map<String, String>.from(jsonDecode(json));
      final card = BusinessCard.fromMap(map);
      return (card: card, cardId: cardId);
    } catch (_) {
      return null;
    }
  }

  static String cardIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.length > 1) return uri.pathSegments[1];
    } catch (_) {}
    return '';
  }
}
