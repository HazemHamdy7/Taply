import 'package:flutter/material.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/shared/template_engine/template_loader.dart';
import 'package:business_card/shared/template_engine/template_renderer.dart';

class TemplateGalleryScreen extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String>? onSelected;

  const TemplateGalleryScreen({
    super.key,
    this.selectedId,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final templates = TemplateLoader.all;
    if (templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.noTemplates),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.templateGallery)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.67 / 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final t = templates[index];
            final selected = t.id == selectedId;
            return GestureDetector(
              onTap: () {
                onSelected?.call(t.id);
                Navigator.pop(context, t.id);
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: TemplateRenderer(
                      templateId: t.id,
                      fieldValues: {
                        'fullName': 'John Doe',
                        'jobTitle': 'CEO',
                        'companyName': 'Acme Inc',
                        'tagline': 'Excellence in every detail',
                        'mobileNumber': '+1 (555) 123-4567',
                        'email': 'john@acme.com',
                        'website': 'acme.com',
                      },
                      width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
                    ),
                  ),
                  if (selected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
