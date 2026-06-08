import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/domain/entities/card_template.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/business_card/presentation/widgets/business_card_widget.dart';
import 'package:business_card/shared/data/country_codes.dart';
import 'package:business_card/shared/widgets/app_text_field.dart';
import 'package:business_card/shared/widgets/phone_field.dart';

class CreateCardScreen extends StatefulWidget {
  final BusinessCard? existingCard;

  const CreateCardScreen({super.key, this.existingCard});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _taglineCtrl;
  late final TextEditingController _jobTitleCtrl;
  late final TextEditingController _companyNameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _mobileCtrl2;
  late final TextEditingController _whatsappCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _facebookCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _telegramCtrl;
  late final TextEditingController _youtubeCtrl;
  late final TextEditingController _xCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _aboutMeCtrl;

  String? _profileImagePath;
  String _selectedTemplateId = 'default';
  CountryCode _mobileCountry = countryCodes.firstWhere((c) => c.dialCode == '+20');
  CountryCode _mobile2Country = countryCodes.firstWhere((c) => c.dialCode == '+20');
  CountryCode _whatsappCountry = countryCodes.firstWhere((c) => c.dialCode == '+20');

  BusinessCard get _previewCard => BusinessCard(
        id: widget.existingCard?.id ?? '',
        profileImagePath: _profileImagePath,
        fullName: _fullNameCtrl.text,
        tagline: _taglineCtrl.text,
        jobTitle: _jobTitleCtrl.text,
        companyName: _companyNameCtrl.text,
        mobileNumber: _prefixed(_mobileCountry, _mobileCtrl.text),
        mobileNumber2: _prefixed(_mobile2Country, _mobileCtrl2.text),
        whatsappNumber: _prefixed(_whatsappCountry, _whatsappCtrl.text),
        email: _emailCtrl.text,
        website: _websiteCtrl.text,
        linkedin: _linkedinCtrl.text,
        facebook: _facebookCtrl.text,
        instagram: _instagramCtrl.text,
        telegram: _telegramCtrl.text,
        youtube: _youtubeCtrl.text,
        x: _xCtrl.text,
        address: _addressCtrl.text,
        aboutMe: _aboutMeCtrl.text,
        templateId: _selectedTemplateId,
      );

  String _prefixed(CountryCode code, String local) {
    final trimmed = local.trim();
    if (trimmed.isEmpty) return '';
    final cleaned = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
    return '${code.dialCode}$cleaned';
  }

  String _stripCode(String full, CountryCode _) {
    if (full.isEmpty) return '';
    for (final c in countryCodes) {
      if (full.startsWith(c.dialCode)) return full.substring(c.dialCode.length);
    }
    // No dial code found — treat the whole string as local number
    return full;
  }

  CountryCode _findCode(String full) {
    for (final c in countryCodes) {
      if (full.startsWith(c.dialCode)) return c;
    }
    return countryCodes.firstWhere((c) => c.dialCode == '+20');
  }

  @override
  void initState() {
    super.initState();
    final c = widget.existingCard;
    _fullNameCtrl = TextEditingController(text: c?.fullName ?? '');
    _taglineCtrl = TextEditingController(text: c?.tagline ?? '');
    _jobTitleCtrl = TextEditingController(text: c?.jobTitle ?? '');
    _companyNameCtrl = TextEditingController(text: c?.companyName ?? '');
    _mobileCtrl = TextEditingController(text: _stripCode(c?.mobileNumber ?? '', _mobileCountry));
    _mobileCtrl2 = TextEditingController(text: '');
    _whatsappCtrl = TextEditingController(text: _stripCode(c?.whatsappNumber ?? '', _whatsappCountry));
    _emailCtrl = TextEditingController(text: c?.email ?? '');
    _websiteCtrl = TextEditingController(text: c?.website ?? '');
    _linkedinCtrl = TextEditingController(text: c?.linkedin ?? '');
    _facebookCtrl = TextEditingController(text: c?.facebook ?? '');
    _instagramCtrl = TextEditingController(text: c?.instagram ?? '');
    _telegramCtrl = TextEditingController(text: c?.telegram ?? '');
    _youtubeCtrl = TextEditingController(text: c?.youtube ?? '');
    _xCtrl = TextEditingController(text: c?.x ?? '');
    _addressCtrl = TextEditingController(text: c?.address ?? '');
    _aboutMeCtrl = TextEditingController(text: c?.aboutMe ?? '');
    _profileImagePath = c?.profileImagePath;
    _selectedTemplateId = c?.templateId ?? 'default';
    if (c != null) {
      _mobileCountry = _findCode(c.mobileNumber);
      _whatsappCountry = _findCode(c.whatsappNumber);
      _mobileCtrl.text = _stripCode(c.mobileNumber, _mobileCountry);
      _whatsappCtrl.text = _stripCode(c.whatsappNumber, _whatsappCountry);
    }

    // Listen to all controllers for live preview rebuild
    final controllers = [
      _fullNameCtrl, _taglineCtrl, _jobTitleCtrl, _companyNameCtrl,
      _mobileCtrl, _mobileCtrl2, _whatsappCtrl, _emailCtrl, _websiteCtrl,
      _linkedinCtrl, _facebookCtrl, _instagramCtrl, _telegramCtrl,
      _youtubeCtrl, _xCtrl, _addressCtrl, _aboutMeCtrl,
    ];
    for (final ctrl in controllers) {
      ctrl.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    final controllers = [
      _fullNameCtrl, _taglineCtrl, _jobTitleCtrl, _companyNameCtrl,
      _mobileCtrl, _mobileCtrl2, _whatsappCtrl, _emailCtrl, _websiteCtrl,
      _linkedinCtrl, _facebookCtrl, _instagramCtrl, _telegramCtrl,
      _youtubeCtrl, _xCtrl, _addressCtrl, _aboutMeCtrl,
    ];
    for (final ctrl in controllers) {
      ctrl.removeListener(_onFieldChanged);
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(source: source, maxWidth: 512);
    if (file != null) {
      setState(() => _profileImagePath = file.path);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.selectFromGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.removePhoto,
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _profileImagePath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final card = BusinessCard(
      id: widget.existingCard?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      profileImagePath: _profileImagePath,
      fullName: _fullNameCtrl.text.trim(),
      tagline: _taglineCtrl.text.trim(),
      jobTitle: _jobTitleCtrl.text.trim(),
      companyName: _companyNameCtrl.text.trim(),
      mobileNumber: _prefixed(_mobileCountry, _mobileCtrl.text),
      mobileNumber2: _prefixed(_mobile2Country, _mobileCtrl2.text),
      whatsappNumber: _prefixed(_whatsappCountry, _whatsappCtrl.text),
      email: _emailCtrl.text.trim(),
      website: _websiteCtrl.text.trim(),
      linkedin: _linkedinCtrl.text.trim(),
      facebook: _facebookCtrl.text.trim(),
      instagram: _instagramCtrl.text.trim(),
      telegram: _telegramCtrl.text.trim(),
      youtube: _youtubeCtrl.text.trim(),
      x: _xCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      aboutMe: _aboutMeCtrl.text.trim(),
      templateId: _selectedTemplateId,
    );

    await context.read<BusinessCardCubit>().saveCard(card);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingCard != null
            ? AppLocalizations.of(context)!.editCard
            : AppLocalizations.of(context)!.createCard),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLivePreview(),
              const SizedBox(height: 20),
              _buildTemplatePicker(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showImagePicker,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImagePath != null
                      ? FileImage(File(_profileImagePath!))
                      : null,
                  child: _profileImagePath == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _showImagePicker,
                child: Text(AppLocalizations.of(context)!.profileImage),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _fullNameCtrl,
                label: AppLocalizations.of(context)!.fullName,
                prefixIcon: const Icon(Icons.person),
                validator: (v) => v?.isEmpty == true ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _taglineCtrl,
                label: AppLocalizations.of(context)!.tagline,
                prefixIcon: const Icon(Icons.short_text),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _jobTitleCtrl,
                label: AppLocalizations.of(context)!.jobTitle,
                prefixIcon: const Icon(Icons.work),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _companyNameCtrl,
                label: AppLocalizations.of(context)!.companyName,
                prefixIcon: const Icon(Icons.business),
              ),
              const SizedBox(height: 12),
              PhoneField(
                controller: _mobileCtrl,
                label: AppLocalizations.of(context)!.mobileNumber,
                icon: Icons.phone,
                selectedCountry: _mobileCountry,
                onCountryChanged: (c) => setState(() => _mobileCountry = c),
              ),
              const SizedBox(height: 12),
              PhoneField(
                controller: _mobileCtrl2,
                label: AppLocalizations.of(context)!.mobileNumber2,
                icon: Icons.phone,
                selectedCountry: _mobile2Country,
                onCountryChanged: (c) => setState(() => _mobile2Country = c),
              ),
              const SizedBox(height: 12),
              PhoneField(
                controller: _whatsappCtrl,
                label: AppLocalizations.of(context)!.whatsappNumber,
                icon: Icons.chat,
                selectedCountry: _whatsappCountry,
                onCountryChanged: (c) => setState(() => _whatsappCountry = c),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailCtrl,
                label: AppLocalizations.of(context)!.email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _websiteCtrl,
                label: AppLocalizations.of(context)!.website,
                keyboardType: TextInputType.url,
                prefixIcon: const Icon(Icons.language),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _linkedinCtrl,
                label: AppLocalizations.of(context)!.linkedin,
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _facebookCtrl,
                label: AppLocalizations.of(context)!.facebook,
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _instagramCtrl,
                label: AppLocalizations.of(context)!.instagram,
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _telegramCtrl,
                label: AppLocalizations.of(context)!.telegram,
                prefixIcon: const Icon(Icons.send),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _youtubeCtrl,
                label: AppLocalizations.of(context)!.youtube,
                prefixIcon: const Icon(Icons.videocam),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _xCtrl,
                label: AppLocalizations.of(context)!.xTwitter,
                prefixIcon: const Icon(Icons.alternate_email),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _addressCtrl,
                label: AppLocalizations.of(context)!.address,
                prefixIcon: const Icon(Icons.location_on),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _aboutMeCtrl,
                label: AppLocalizations.of(context)!.aboutMe,
                maxLines: 3,
                prefixIcon: const Icon(Icons.info),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(AppLocalizations.of(context)!.save),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLivePreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BusinessCardWidget(
            card: _previewCard,
            width: MediaQuery.of(context).size.width - 32,
          ),
        ),
      ],
    );
  }

  Widget _buildTemplatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.cardTheme, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final result = await context.push<String>('/template-gallery',
                    extra: _selectedTemplateId);
                if (result != null) {
                  setState(() => _selectedTemplateId = result);
                }
              },
              icon: const Icon(Icons.grid_view, size: 18),
              label: Text(AppLocalizations.of(context)!.browseAll),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: CardTemplate.all.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final t = CardTemplate.all[index];
              final selected = t.id == _selectedTemplateId;
              return GestureDetector(
                onTap: () => setState(() => _selectedTemplateId = t.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: t.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: selected
                        ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
                        : null,
                    boxShadow: selected
                        ? [BoxShadow(color: t.gradientColors.first.withValues(alpha: 0.4), blurRadius: 8)]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      t.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.textColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
