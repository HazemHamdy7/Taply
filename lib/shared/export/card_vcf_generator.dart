import 'package:business_card/features/business_card/domain/entities/business_card.dart';

class CardVcfGenerator {
  static String generate(BusinessCard card) {
    final buf = StringBuffer();
    buf.writeln('BEGIN:VCARD');
    buf.writeln('VERSION:3.0');

    final fn = _esc(card.fullName);
    buf.writeln('FN:$fn');

    final parts = fn.split(' ').where((s) => s.isNotEmpty).toList();
    final lastName = parts.length > 1 ? parts.last : '';
    final firstName = parts.isNotEmpty ? parts.first : fn;
    buf.writeln('N:$lastName;$firstName;;;');

    if (card.tagline.isNotEmpty) buf.writeln('NICKNAME:${_esc(card.tagline)}');
    if (card.jobTitle.isNotEmpty) buf.writeln('TITLE:${_esc(card.jobTitle)}');
    if (card.companyName.isNotEmpty) buf.writeln('ORG:${_esc(card.companyName)}');
    if (card.mobileNumber.isNotEmpty) buf.writeln('TEL;TYPE=CELL:${card.mobileNumber}');
    if (card.mobileNumber2.isNotEmpty) buf.writeln('TEL;TYPE=CELL:${card.mobileNumber2}');
    if (card.whatsappNumber.isNotEmpty) buf.writeln('TEL;TYPE=CELL:${card.whatsappNumber}');
    if (card.email.isNotEmpty) buf.writeln('EMAIL:${card.email}');

    if (card.website.isNotEmpty) {
      final url = card.website.startsWith('http') ? card.website : 'https://${card.website}';
      buf.writeln('URL:$url');
    }

    if (card.address.isNotEmpty) {
      buf.writeln('ADR:;;${_esc(card.address)}');
    }

    if (card.linkedin.isNotEmpty) buf.writeln('X-SOCIAL-LINK;TYPE=LinkedIn:${card.linkedin}');
    if (card.facebook.isNotEmpty) buf.writeln('X-SOCIAL-LINK;TYPE=Facebook:${card.facebook}');
    if (card.instagram.isNotEmpty) buf.writeln('X-SOCIAL-LINK;TYPE=Instagram:${card.instagram}');
    if (card.telegram.isNotEmpty) buf.writeln('X-SOCIAL-LINK;TYPE=Telegram:${card.telegram}');
    if (card.youtube.isNotEmpty) buf.writeln('X-SOCIAL-LINK;TYPE=YouTube:${card.youtube}');
    if (card.x.isNotEmpty) buf.writeln('X-SOCIAL-LINK;TYPE=Twitter:${card.x}');

    if (card.aboutMe.isNotEmpty) buf.writeln('NOTE:${_esc(card.aboutMe)}');

    buf.writeln('END:VCARD');
    return buf.toString();
  }

  static String _esc(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(':', '\\:')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '');
  }
}
