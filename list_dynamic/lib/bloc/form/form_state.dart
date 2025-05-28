import 'package:equatable/equatable.dart';

import '../../model/form_element_model.dart';
import '../../model/form_rule_model.dart';

abstract class ForumState extends Equatable {
  const ForumState();

  @override
  List<Object?> get props => [];
}

class FormInitial extends ForumState {}

class FormLoading extends ForumState {}

class FormLoaded extends ForumState {
  final List<FormElementModel> formElements;
  final List<FormRuleModel> rule;

  final List<String> availableYears;
  final List<String> availableMonths;
  final List<String> availableDays;

  final String? selectedYear;
  final String? selectedMonth;
  final String? selectedDay;
  final String? selectedGender;
  final String? religion;

  final Map<String, String> fields;

  final List<FormElementModel> requiredFields;
  final List<FormElementModel> optionalFields;

  final bool isOptionEnabled;
  final Map<String, String?>? vaildationError;
  const FormLoaded({
    required this.formElements,
    required this.rule,
    required this.availableYears,
    required this.availableMonths,
    required this.availableDays,
    this.selectedYear,
    this.selectedMonth,
    this.selectedDay,
    this.selectedGender,
    this.religion,
    required this.fields,
    this.isOptionEnabled = false,
    required this.requiredFields,
    required this.optionalFields,
    this.vaildationError,
  });

  factory FormLoaded.fromJson(Map<String, dynamic> json) {
    return FormLoaded(
      formElements:
          (json['formElements'] as List)
              .map((e) => FormElementModel.fromJson(e))
              .toList(),
      rule:
          (json['rule'] as List<dynamic>? ?? [])
              .map((e) => FormRuleModel.fromJson(e))
              .toList(),

      selectedYear: json['selectedYear'],
      selectedMonth: json['selectedMonth'],
      selectedDay: json['selectedDay'],
      selectedGender: json['selectedGender'],
      religion: json['religion'],

      fields:
          json['fields'] != null
              ? Map<String, String>.from(json['fields'])
              : {},

      isOptionEnabled: json['isOptionEnabled'] ?? false,

      requiredFields:
          (json['requiredFields'] as List)
              .map((e) => FormElementModel.fromJson(e))
              .toList(),

      optionalFields:
          (json['optionalFields'] as List)
              .map((e) => FormElementModel.fromJson(e))
              .toList(),
      availableYears: [],
      availableMonths: [],
      availableDays: [],
      vaildationError: {},
    );
  }

  FormLoaded copyWith({
    List<FormElementModel>? formElements,
    List<FormRuleModel>? rule,
    List<String>? availableYears,
    List<String>? availableMonths,
    List<String>? availableDays,
    String? selectedYear,
    String? selectedMonth,
    String? selectedDay,
    String? selectedGender,
    String? religion,
    Map<String, String>? fields,
    bool? isOptionEnabled,
    List<FormElementModel>? requiredFields,
    List<FormElementModel>? optionalFields,
    Map<String, String?>? vaildationError,
  }) {
    return FormLoaded(
      formElements: formElements ?? this.formElements,
      rule: rule ?? this.rule,
      availableYears: availableYears ?? this.availableYears,
      availableMonths: availableMonths ?? this.availableMonths,
      availableDays: availableDays ?? this.availableDays,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedGender: selectedGender ?? this.selectedGender,
      religion: religion ?? this.religion,
      fields: fields ?? this.fields,
      isOptionEnabled: isOptionEnabled ?? this.isOptionEnabled,
      requiredFields: requiredFields ?? this.requiredFields,
      optionalFields: optionalFields ?? this.optionalFields,
      vaildationError: vaildationError ?? this.vaildationError,
    );
  }

  @override
  List<Object?> get props => [
    formElements,
    rule,
    availableYears,
    availableMonths,
    availableDays,
    selectedYear,
    selectedMonth,
    selectedDay,
    selectedGender,
    religion,
    fields,
    isOptionEnabled,
    requiredFields,
    optionalFields,
    vaildationError,
  ];
}
