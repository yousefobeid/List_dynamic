import 'package:equatable/equatable.dart';

import '../../model/form_element_model.dart';

abstract class ForumState extends Equatable {
  const ForumState();

  @override
  List<Object?> get props => [];
}

class FormInitial extends ForumState {}

class FormLoading extends ForumState {}

class FormLoaded extends ForumState {
  final List<FormElementModel> formElements;

  final List<String> availableYears;
  final List<String> availableMonths;
  final List<String> availableDays;

  final String? selectedYear;
  final String? selectedMonth;
  final String? selectedDay;

  final String? religion;
  final String? selectedGender;

  final Map<String, String> fields;

  final List<FormElementModel> requiredFields;
  final List<FormElementModel> optionalFields;

  final bool isOptionEnabled;
  const FormLoaded({
    required this.formElements,
    this.selectedYear,
    this.selectedMonth,
    this.selectedDay,
    required this.availableDays,
    required this.availableMonths,
    required this.availableYears,
    this.religion,

    this.selectedGender,

    required this.fields,
    this.isOptionEnabled = false,
    required this.requiredFields,

    required this.optionalFields,
  });

  factory FormLoaded.fromJson(Map<String, dynamic> json) {
    return FormLoaded(
      formElements:
          (json['formElements'] as List)
              .map((element) => FormElementModel.fromJson(element))
              .toList(),
      selectedYear: json['selectedYear'],
      selectedMonth: json['selectedMonth'],
      selectedDay: json['selectedDay'],
      religion: json['religion'],
      selectedGender: json['selectedGender'],
      fields:
          json['fields'] != null
              ? Map<String, String>.from(json['fields'])
              : {},
      isOptionEnabled: json['isOptionEnabled'] ?? false,
      requiredFields:
          (json['requiredFields'] as List)
              .map((element) => FormElementModel.fromJson(element))
              .toList(),
      optionalFields:
          (json['optionalFields'] as List)
              .map((element) => FormElementModel.fromJson(element))
              .toList(),
      availableDays: [],
      availableMonths: [],
      availableYears: [],
    );
  }

  FormLoaded copyWith({
    String? selectedGender,

    String? selectedYear,
    String? selectedMonth,
    String? selectedDay,

    List<String>? days,

    String? religion,
    List<FormElementModel>? formElements,
    Map<String, String>? fields,
    bool? isOptionEnabled,
    List<FormElementModel>? requiredFields,
    List<FormElementModel>? optionalFields,
    List<String>? yearOptions,
    List<String>? availableDays,
    List<String>? availableMonths,
    List<String>? availableYears,
  }) {
    return FormLoaded(
      availableDays: availableDays ?? this.availableDays,
      availableMonths: availableMonths ?? this.availableMonths,
      availableYears: availableYears ?? this.availableYears,
      formElements: formElements ?? this.formElements,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,

      religion: religion ?? this.religion,
      selectedGender: selectedGender ?? this.selectedGender,
      fields: fields ?? this.fields,
      isOptionEnabled: isOptionEnabled ?? this.isOptionEnabled,
      optionalFields: optionalFields ?? this.optionalFields,
      requiredFields: requiredFields ?? this.requiredFields,
    );
  }

  @override
  List<Object?> get props => [
    formElements,
    selectedYear,
    selectedMonth,
    selectedDay,
    religion,
    selectedGender,
    fields,
    isOptionEnabled,
    requiredFields,
    optionalFields,
    availableDays,
    availableMonths,
    availableYears,
  ];
}
