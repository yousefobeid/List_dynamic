import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object?> get props => [];
}

class LoadFormDataEvent extends FormEvent {
  const LoadFormDataEvent();
}

class UpdateBirthDateEvent extends FormEvent {
  final String year;
  final String month;
  final String day;

  const UpdateBirthDateEvent({
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  List<Object?> get props => [year, month, day];
}

class UpdateEvent extends FormEvent {
  final String id;
  final String value;

  const UpdateEvent({required this.id, required this.value});

  @override
  List<Object?> get props => [id, value];
}

class ResetFormEvent extends FormEvent {
  const ResetFormEvent();
  @override
  List<Object?> get props => [];
}

class ToggleOptionEvent extends FormEvent {
  final bool showOption;
  const ToggleOptionEvent({this.showOption = false});
  @override
  List<Object?> get props => [showOption];
}
