import 'package:flutter/material.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/shared/data/country_codes.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final CountryCode? selectedCountry;
  final ValueChanged<CountryCode>? onCountryChanged;

  const PhoneField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.selectedCountry,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final country = selectedCountry ?? countryCodes.firstWhere((c) => c.dialCode == '+20');
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: InkWell(
          onTap: () => _showPicker(context),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(country.flag, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 4),
                Text(country.dialCode, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CountryPickerSheet(onSelected: onCountryChanged ?? (_) {}),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final ValueChanged<CountryCode> onSelected;
  const _CountryPickerSheet({required this.onSelected});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CountryCode> get _filtered {
    if (_query.isEmpty) return countryCodes;
    final q = _query.toLowerCase();
    return countryCodes.where((c) =>
      c.name.toLowerCase().contains(q) ||
      c.dialCode.contains(_query) ||
      c.code.toLowerCase().contains(q)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(AppLocalizations.of(context)!.selectCountryCode, style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchCountry,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  return ListTile(
                    leading: Text(c.flag, style: const TextStyle(fontSize: 28)),
                    title: Text(c.name),
                    trailing: Text(c.dialCode, style: const TextStyle(fontWeight: FontWeight.w500)),
                    onTap: () {
                      widget.onSelected(c);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
