import 'package:list_dynamic/model/form_element_model.dart';
import 'package:list_dynamic/model/form_rule_model.dart';

class FormModel {
  final List<FormElementModel> elements;
  final List<FormRuleModel> rules;

  FormModel({required this.elements, required this.rules});
  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      elements:
          (json['elements'] as List<dynamic>?)
              ?.map((e) => FormElementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rules:
          (json['rules'] as List<dynamic>?)
              ?.map((r) => FormRuleModel.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'elements': elements.map((e) => e.toJson()).toList(),
      'rules': rules.map((r) => r.toJson()).toList(),
    };
  }
}
