import 'package:flutter/material.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/shared/integration/card_engine_widget.dart';

class BusinessCardWidget extends StatelessWidget {
  final BusinessCard card;
  final double width;

  const BusinessCardWidget({super.key, required this.card, required this.width});

  @override
  Widget build(BuildContext context) {
    return CardEngineWidget(card: card, width: width);
  }
}
