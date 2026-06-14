import 'dart:ui' as ui;

import '../avatar/avatar_runtime.dart';
import '../field/data_provider.dart';
import '../field/field_binding.dart';
import '../qr/qr_runtime.dart';
import '../runtime_cache.dart';

class WidgetRuntime {
  final FieldBinding fieldBinding;
  final QRRuntime qrRuntime;
  final AvatarRuntime avatarRuntime;
  final RuntimeCache? cache;

  WidgetRuntime({
    FieldBinding? fieldBinding,
    QRRuntime? qrRuntime,
    AvatarRuntime? avatarRuntime,
    RuntimeCache? cache,
  })  : fieldBinding = fieldBinding ?? FieldBinding(),
        qrRuntime = qrRuntime ?? QRRuntime(cache: cache),
        avatarRuntime = avatarRuntime ?? AvatarRuntime(cache: cache),
        cache = cache;

  Future<AvatarWidgetData> createAvatar(AvatarWidgetConfig config, BusinessCardData data) async {
    final source = _resolveField(config.source, data);
    final size = config.size ?? 200;

    ui.Image? image;
    if (source != null && source.isNotEmpty) {
      try {
        image = await avatarRuntime.loadAvatar(
          source,
          type: config.sourceType ?? AvatarSource.network,
          size: size,
        );
      } catch (_) {}
    }

    return AvatarWidgetData(
      image: image,
      size: size,
      shape: config.shape ?? 'circle',
      borderColor: config.borderColor,
      borderWidth: config.borderWidth,
    );
  }

  Future<QRCodeWidgetData> createQRCode(QRCodeWidgetConfig config, BusinessCardData data) async {
    final content = _resolveField(config.content, data) ?? '';
    final size = config.size ?? 200;

    ui.Image? image;
    if (content.isNotEmpty) {
      try {
        image = await qrRuntime.generateQRImage(
          content,
          size: size,
          foreground: config.foreground ?? const ui.Color(0xFF000000),
          background: config.background ?? const ui.Color(0xFFFFFFFF),
        );
      } catch (_) {}
    }

    return QRCodeWidgetData(
      image: image,
      size: size,
      content: content,
    );
  }

  TextWidgetData createText(TextWidgetConfig config, BusinessCardData data) {
    final text = _resolveField(config.source, data) ?? '';
    return TextWidgetData(
      text: text,
      fontSize: config.fontSize,
      color: config.color,
      fontWeight: config.fontWeight,
      maxLines: config.maxLines,
      textAlign: config.textAlign,
    );
  }

  ImageWidgetData createImage(ImageWidgetConfig config, BusinessCardData data) {
    final source = _resolveField(config.source, data);
    return ImageWidgetData(
      source: source,
      width: config.width,
      height: config.height,
      fit: config.fit,
    );
  }

  DividerWidgetData createDivider(DividerWidgetConfig config) {
    return DividerWidgetData(
      thickness: config.thickness ?? 1,
      color: config.color,
      margin: config.margin,
    );
  }

  SocialIconsWidgetData createSocialIcons(SocialIconsWidgetConfig config, BusinessCardData data) {
    final icons = <SocialIconData>[];
    for (final icon in config.icons) {
      final url = _resolveField(icon.url, data);
      icons.add(SocialIconData(
        platform: icon.platform,
        url: url ?? '',
        label: icon.label,
      ));
    }
    return SocialIconsWidgetData(icons: icons);
  }

  ContactButtonsWidgetData createContactButtons(
    ContactButtonsWidgetConfig config,
    BusinessCardData data,
  ) {
    final buttons = <ContactButtonData>[];
    for (final btn in config.buttons) {
      final value = _resolveField(btn.value, data);
      buttons.add(ContactButtonData(
        type: btn.type,
        value: value ?? '',
        label: btn.label,
        icon: btn.icon,
      ));
    }
    return ContactButtonsWidgetData(buttons: buttons);
  }

  String? _resolveField(String? source, BusinessCardData data) {
    if (source == null) return null;
    if (source.contains(r'$')) {
      return fieldBinding.fieldResolver.resolve(source, data);
    }
    return source;
  }
}

class AvatarWidgetConfig {
  final String source;
  final double? size;
  final AvatarSource? sourceType;
  final String? shape;
  final String? borderColor;
  final double? borderWidth;

  const AvatarWidgetConfig({
    required this.source,
    this.size,
    this.sourceType,
    this.shape,
    this.borderColor,
    this.borderWidth,
  });
}

class QRCodeWidgetConfig {
  final String content;
  final double? size;
  final ui.Color? foreground;
  final ui.Color? background;

  const QRCodeWidgetConfig({
    required this.content,
    this.size,
    this.foreground,
    this.background,
  });
}

class TextWidgetConfig {
  final String source;
  final double? fontSize;
  final String? color;
  final String? fontWeight;
  final int? maxLines;
  final String? textAlign;

  const TextWidgetConfig({
    required this.source,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  });
}

class ImageWidgetConfig {
  final String source;
  final double? width;
  final double? height;
  final String? fit;

  const ImageWidgetConfig({
    required this.source,
    this.width,
    this.height,
    this.fit,
  });
}

class DividerWidgetConfig {
  final double? thickness;
  final String? color;
  final double? margin;

  const DividerWidgetConfig({
    this.thickness,
    this.color,
    this.margin,
  });
}

class SocialIconsWidgetConfig {
  final List<SocialIconConfig> icons;

  const SocialIconsWidgetConfig({required this.icons});
}

class SocialIconConfig {
  final String platform;
  final String url;
  final String? label;

  const SocialIconConfig({
    required this.platform,
    required this.url,
    this.label,
  });
}

class ContactButtonsWidgetConfig {
  final List<ContactButtonConfig> buttons;

  const ContactButtonsWidgetConfig({required this.buttons});
}

class ContactButtonConfig {
  final String type;
  final String value;
  final String? label;
  final String? icon;

  const ContactButtonConfig({
    required this.type,
    required this.value,
    this.label,
    this.icon,
  });
}

class AvatarWidgetData {
  final ui.Image? image;
  final double size;
  final String shape;
  final String? borderColor;
  final double? borderWidth;

  const AvatarWidgetData({
    this.image,
    required this.size,
    this.shape = 'circle',
    this.borderColor,
    this.borderWidth,
  });
}

class QRCodeWidgetData {
  final ui.Image? image;
  final double size;
  final String content;

  const QRCodeWidgetData({
    this.image,
    required this.size,
    required this.content,
  });
}

class TextWidgetData {
  final String text;
  final double? fontSize;
  final String? color;
  final String? fontWeight;
  final int? maxLines;
  final String? textAlign;

  const TextWidgetData({
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  });
}

class ImageWidgetData {
  final String? source;
  final double? width;
  final double? height;
  final String? fit;

  const ImageWidgetData({
    this.source,
    this.width,
    this.height,
    this.fit,
  });
}

class DividerWidgetData {
  final double thickness;
  final String? color;
  final double? margin;

  const DividerWidgetData({
    this.thickness = 1,
    this.color,
    this.margin,
  });
}

class SocialIconsWidgetData {
  final List<SocialIconData> icons;

  const SocialIconsWidgetData({required this.icons});
}

class SocialIconData {
  final String platform;
  final String url;
  final String? label;

  const SocialIconData({
    required this.platform,
    required this.url,
    this.label,
  });
}

class ContactButtonsWidgetData {
  final List<ContactButtonData> buttons;

  const ContactButtonsWidgetData({required this.buttons});
}

class ContactButtonData {
  final String type;
  final String value;
  final String? label;
  final String? icon;

  const ContactButtonData({
    required this.type,
    required this.value,
    this.label,
    this.icon,
  });
}
