import 'package:flutter/widgets.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';

String localizedCategoryName(BuildContext context, Category cat) {
  if (!cat.isDefault) return cat.name;
  final loc = AppLocalizations.of(context)!;
  return switch (cat.id) {
    'default_clients' => loc.defaultClients,
    'default_investors' => loc.defaultInvestors,
    'default_developers' => loc.defaultDevelopers,
    'default_designers' => loc.defaultDesigners,
    'default_partners' => loc.defaultPartners,
    'default_friends' => loc.defaultFriends,
    _ => cat.name,
  };
}
