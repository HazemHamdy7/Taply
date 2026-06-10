import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum ValidationCategory {
  @JsonValue('metadata')
  metadata,
  @JsonValue('canvas')
  canvas,
  @JsonValue('variables')
  variables,
  @JsonValue('assets')
  assets,
  @JsonValue('scene')
  scene,
  @JsonValue('paint')
  paint,
  @JsonValue('widget')
  widget,
  @JsonValue('components')
  components,
  @JsonValue('animations')
  animations,
  @JsonValue('states')
  states,
  @JsonValue('general')
  general;

  String get codePrefix {
    return switch (this) {
      ValidationCategory.metadata => 'META',
      ValidationCategory.canvas => 'CANVAS',
      ValidationCategory.variables => 'VAR',
      ValidationCategory.assets => 'ASSET',
      ValidationCategory.scene => 'SCENE',
      ValidationCategory.paint => 'PAINT',
      ValidationCategory.widget => 'WIDGET',
      ValidationCategory.components => 'COMP',
      ValidationCategory.animations => 'ANIM',
      ValidationCategory.states => 'STATE',
      ValidationCategory.general => 'GEN',
    };
  }
}
