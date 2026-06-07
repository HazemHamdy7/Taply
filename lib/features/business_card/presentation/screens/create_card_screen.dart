import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/shared/widgets/app_text_field.dart';

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
  late final TextEditingController _jobTitleCtrl;
  late final TextEditingController _companyNameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _whatsappCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _facebookCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _telegramCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _aboutMeCtrl;

  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    final c = widget.existingCard;
    _fullNameCtrl = TextEditingController(text: c?.fullName ?? '');
    _jobTitleCtrl = TextEditingController(text: c?.jobTitle ?? '');
    _companyNameCtrl = TextEditingController(text: c?.companyName ?? '');
    _mobileCtrl = TextEditingController(text: c?.mobileNumber ?? '');
    _whatsappCtrl = TextEditingController(text: c?.whatsappNumber ?? '');
    _emailCtrl = TextEditingController(text: c?.email ?? '');
    _websiteCtrl = TextEditingController(text: c?.website ?? '');
    _linkedinCtrl = TextEditingController(text: c?.linkedin ?? '');
    _facebookCtrl = TextEditingController(text: c?.facebook ?? '');
    _instagramCtrl = TextEditingController(text: c?.instagram ?? '');
    _telegramCtrl = TextEditingController(text: c?.telegram ?? '');
    _addressCtrl = TextEditingController(text: c?.address ?? '');
    _aboutMeCtrl = TextEditingController(text: c?.aboutMe ?? '');
    _profileImagePath = c?.profileImagePath;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    _companyNameCtrl.dispose();
    _mobileCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _websiteCtrl.dispose();
    _linkedinCtrl.dispose();
    _facebookCtrl.dispose();
    _instagramCtrl.dispose();
    _telegramCtrl.dispose();
    _addressCtrl.dispose();
    _aboutMeCtrl.dispose();
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
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final card = BusinessCard(
      id: widget.existingCard?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      profileImagePath: _profileImagePath,
      fullName: _fullNameCtrl.text.trim(),
      jobTitle: _jobTitleCtrl.text.trim(),
      companyName: _companyNameCtrl.text.trim(),
      mobileNumber: _mobileCtrl.text.trim(),
      whatsappNumber: _whatsappCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      website: _websiteCtrl.text.trim(),
      linkedin: _linkedinCtrl.text.trim(),
      facebook: _facebookCtrl.text.trim(),
      instagram: _instagramCtrl.text.trim(),
      telegram: _telegramCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      aboutMe: _aboutMeCtrl.text.trim(),
    );

    context.read<BusinessCardCubit>().saveCard(card);
    context.go('/card-preview');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingCard != null ? 'Edit Business Card' : 'Create Business Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                child: const Text('Profile Image'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _fullNameCtrl,
                label: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _jobTitleCtrl,
                label: 'Job Title',
                prefixIcon: const Icon(Icons.work),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _companyNameCtrl,
                label: 'Company Name',
                prefixIcon: const Icon(Icons.business),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _mobileCtrl,
                label: 'Mobile Number',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _whatsappCtrl,
                label: 'WhatsApp Number',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.chat),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _websiteCtrl,
                label: 'Website',
                keyboardType: TextInputType.url,
                prefixIcon: const Icon(Icons.language),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _linkedinCtrl,
                label: 'LinkedIn',
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _facebookCtrl,
                label: 'Facebook',
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _instagramCtrl,
                label: 'Instagram',
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _telegramCtrl,
                label: 'Telegram',
                prefixIcon: const Icon(Icons.send),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _addressCtrl,
                label: 'Address',
                prefixIcon: const Icon(Icons.location_on),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _aboutMeCtrl,
                label: 'About Me',
                maxLines: 3,
                prefixIcon: const Icon(Icons.info),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
