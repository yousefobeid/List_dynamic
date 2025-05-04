import 'package:equatable/equatable.dart';

import '../model/form_element_model.dart';

abstract class ForumState extends Equatable {
  const ForumState();

  @override
  List<Object?> get props => [];
}

class FormInitial extends ForumState {}

class FormLoading extends ForumState {}

class FormLoaded extends ForumState {
  final List<FormElementModel> formElements;
  final String? selectedYear;
  final String? selectedMonth;
  final String? selectedDay;
  final String? religion;
  final String? selectedGender;
  final Map<String, String> fields;

  const FormLoaded({
    required this.formElements,
    this.selectedYear,
    this.selectedMonth,
    this.selectedDay,
    this.religion,
    this.selectedGender,
    required this.fields,
  });

  // Factory method to create FormLoaded from JSON
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
  }) {
    return FormLoaded(
      formElements: formElements ?? this.formElements,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      religion: religion ?? this.religion,
      selectedGender: selectedGender ?? this.selectedGender,
      fields: fields ?? this.fields,
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
  ];
}
