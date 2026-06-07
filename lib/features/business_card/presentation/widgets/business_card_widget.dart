import 'package:flutter/material.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/shared/template_engine/template_renderer.dart';

class BusinessCardWidget extends StatelessWidget {
  final BusinessCard card;
  final double width;

  const BusinessCardWidget({super.key, required this.card, required this.width});

  Map<String, String> _fieldValues() {
    return {
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
    };
  }

  @override
  Widget build(BuildContext context) {
    return TemplateRenderer(
      templateId: card.templateId,
      fieldValues: _fieldValues(),
      width: width,
      profileImagePath: card.profileImagePath,
    );
  }
}
