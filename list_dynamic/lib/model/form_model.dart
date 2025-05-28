import 'package:list_dynamic/model/form_element_model.dart';
import 'package:list_dynamic/model/form_rule_model.dart';

class FormModel {
  final List<FormElementModel> elements;
  final List<FormRuleModel> rules;

  FormModel({required this.elements, required this.rules});
}
