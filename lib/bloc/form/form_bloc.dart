import 'package:bloc/bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/core/service/database_helper.dart';
import 'package:list_dynamic/model/form_element_model.dart';
import 'package:list_dynamic/model/form_model.dart';
import 'package:list_dynamic/model/form_rule_model.dart';
import 'package:list_dynamic/repo/repository_form.dart';

class FormBloc extends Bloc<FormEvent, ForumState> {
  final FormRepository formRepository;
  final DatabaseHelper database;
  final FormModel formModel;
  FormBloc(this.formRepository, this.database, this.formModel)
    : super(FormInitial()) {
    on<LoadFormDataEvent>(_onLoadFormData);
    on<UpdateEvent>(_onUpdateEvent);
    on<UpdateBirthDateEvent>(_onUpdateBirthDate);
    on<ResetFormEvent>(_resetFormEvent);
    on<ToggleOptionEvent>(_onToggleOptionalFields);
    on<UpdateGenderEvent>(_onUpdateGenderEvent);
    on<ValidateFormEvent>(_onValidateForm);
  }
  Future<void> _onLoadFormData(
    LoadFormDataEvent event,
    Emitter<ForumState> emit,
  ) async {
    emit(FormLoading());
    final formElements = await formRepository.fetchFormData();
    final requiredFields =
        formModel.elements
            .where((element) => element.isRequired == true)
            .toList();
    final optionalFields =
        formModel.elements
            .where((element) => element.isOption == true)
            .toList();
    emit(
      FormLoaded(
        fields: {},
        formElements: [...formElements.elements],
        rule: formElements.rules,
        selectedYear: null,
        selectedMonth: null,
        selectedDay: null,
        religion: null,
        isOptionEnabled: false,
        requiredFields: requiredFields,
        optionalFields: optionalFields,
        availableDays: [],
        availableMonths: [],
        availableYears: getInitialYears(),
      ),
    );
  }

  List<String> getInitialYears() {
    final currentYear = DateTime.now().year;
    return List.generate(50, (index) => (currentYear - index).toString());
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<ForumState> emit) async {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      final updatedFields = Map<String, String>.from(currentState.fields);
      updatedFields[event.id] = event.value;
      emit(currentState.copyWith(fields: updatedFields));
    }
  }

  void _onUpdateBirthDate(
    UpdateBirthDateEvent event,
    Emitter<ForumState> emit,
  ) {
    if (state is FormLoaded) {
      final int year =
          event.year.isNotEmpty ? int.parse(event.year) : DateTime.now().year;
      final int month = event.month.isNotEmpty ? int.parse(event.month) : 1;
      List<String> generateDays(int year, int month) {
        final lastDay = DateTime(year, month + 1, 0).day;
        return List.generate(lastDay, (i) => (i + 1).toString());
      }

      final currentState = state as FormLoaded;
      List<String> updatedDays = currentState.availableDays;
      if (event.year != currentState.selectedYear ||
          event.month != currentState.selectedMonth) {
        updatedDays = generateDays(year, month);
      }
      String? selectedDay =
          event.day.isNotEmpty ? event.day : currentState.selectedDay;
      if (!updatedDays.contains(selectedDay)) {
        selectedDay = null;
      }
      emit(
        (state as FormLoaded).copyWith(
          selectedYear: event.year.isEmpty ? null : event.year,
          selectedMonth: event.month.isEmpty ? null : event.month,
          selectedDay: selectedDay,
          availableDays: updatedDays,
        ),
      );
    }
  }

  List<String> getAvailableMonths() {
    return List.generate(12, (index) => (index + 1).toString());
  }

  void _onUpdateGenderEvent(UpdateGenderEvent event, Emitter<ForumState> emit) {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;

      final updatedFields = Map<String, String>.from(currentState.fields);

      final selectedGender = event.selectId ?? '';

      final foundElement = currentState.formElements.firstWhere(
        (element) => element.id == event.feildId,
        orElse:
            () => FormElementModel(
              id: event.feildId ?? '',
              key: event.feildId ?? '',
            ),
      );
      final fieldKey = foundElement.key;

      updatedFields[fieldKey] = selectedGender;
      final checkTheRule = currentState.rule.firstWhere((rule) {
        final condition = rule.condition;
        bool success = true;
        for (var key in condition.keys) {
          final expectedValue = condition[key]?.toString().toLowerCase();
          final actualValue =
              updatedFields[key]?.toString().toLowerCase() ?? '';

          if (expectedValue != null && expectedValue != actualValue) {
            success = false;
            break;
          }
        }
        return success;
      }, orElse: () => FormRuleModel(condition: {}, action: {}));

      List<String> availableYears = [];

      if (checkTheRule.action.isNotEmpty &&
          checkTheRule.action['birthDate'] != null &&
          checkTheRule.action['birthDate']['minage'] != null) {
        final birthDateAction = checkTheRule.action['birthDate'];
        final minAge = birthDateAction['minage'];
        final currentYear = DateTime.now().year;

        availableYears =
            List.generate(100, (i) => (currentYear - i).toString())
                .where((year) => (currentYear - int.parse(year)) >= minAge)
                .toList();
      } else {
        availableYears = [];
      }

      emit(
        currentState.copyWith(
          fields: updatedFields,
          selectedGender: selectedGender,
          availableYears: availableYears,
          availableMonths: getAvailableMonths(),
          selectedYear: null,
          selectedMonth: null,
          selectedDay: null,
          availableDays: [],
        ),
      );
    }
  }

  Future<void> _resetFormEvent(
    ResetFormEvent event,
    Emitter<ForumState> emit,
  ) async {
    emit(FormLoading());
    try {
      final elements = await formRepository.fetchFormData();
      emit(
        FormLoaded(
          formElements: [...elements.elements],
          rule: elements.rules,
          fields: {},
          selectedDay: null,
          selectedMonth: null,
          selectedYear: null,
          selectedGender: null,
          religion: null,
          isOptionEnabled: false,
          requiredFields: [],
          optionalFields: [],
          availableDays: [],
          availableMonths: [],
          availableYears: [],
        ),
      );
    } catch (e) {
      print("Error $e");
    }
  }

  void _onToggleOptionalFields(
    ToggleOptionEvent event,
    Emitter<ForumState> emit,
  ) {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      emit(currentState.copyWith(isOptionEnabled: event.showOption));
    }
  }

  Future<void> printFormData() async {
    final allData = await database.getAllData();
    print("All Data: $allData");
  }

  void _onValidateForm(ValidateFormEvent event, Emitter<ForumState> emit) {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      final errors = <String, String?>{};

      for (final element in currentState.formElements) {
        final isRequired = element.isRequired ?? false;
        final value = currentState.fields[element.key];

        if (isRequired && (value == null || value.trim().isEmpty)) {
          errors[element.key] = '*';
        }
      }

      emit(currentState.copyWith(vaildationError: errors));
    }
  }
}
