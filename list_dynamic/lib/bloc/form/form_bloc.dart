import 'package:bloc/bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/data/local/database_helper.dart';
import 'package:list_dynamic/repo/repository_form.dart';

class FormBloc extends Bloc<FormEvent, ForumState> {
  final FormRepository formRepository;
  final DatabaseHelper database;

  FormBloc(this.formRepository, this.database) : super(FormInitial()) {
    on<LoadFormDataEvent>(_onLoadFormData);
    on<UpdateEvent>(_onUpdateEvent);
    on<UpdateBirthDateEvent>(_onUpdateBirthDate);
    on<ResetFormEvent>(_resetFormEvent);
    on<ToggleOptionEvent>(_onToggleOptionalFields);
    on<UpdateGenderEvent>(_onUpdateGenderEvent);
  }
  Future<void> _onLoadFormData(
    LoadFormDataEvent event,
    Emitter<ForumState> emit,
  ) async {
    emit(FormLoading());
    final formElements = await formRepository.fetchFormData();
    final requiredFields =
        formElements.where((element) => element.isRequired == true).toList();
    final optionalFields =
        formElements.where((element) => element.isOption == true).toList();
    emit(
      FormLoaded(
        fields: {},
        formElements: formElements,
        selectedYear: null,
        selectedMonth: null,
        selectedDay: null,
        religion: null,
        isOptionEnabled: false,
        requiredFields: requiredFields,
        optionalFields: optionalFields,
        availableDays: [],
        availableMonths: [],
        availableYears: [],
      ),
    );
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<ForumState> emit) async {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      final updatedFields = Map<String, String>.from(currentState.fields);
      updatedFields[event.id] = event.value;
      // await database.getAllData();
      emit(currentState.copyWith(fields: updatedFields));
    }
  }

  void _onUpdateBirthDate(
    UpdateBirthDateEvent event,
    Emitter<ForumState> emit,
  ) {
    if (state is FormLoaded) {
      final int year = int.tryParse(event.year) ?? DateTime.now().year;
      final int month = int.tryParse(event.month) ?? 1;
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
          selectedYear: event.year,
          selectedMonth: event.month,
          selectedDay: event.day,
          availableDays: updatedDays,
        ),
      );
    }
  }

  Map<String, int> minAgeGender = {"male": 20, "female": 18};
  List<String> getYearBasedOnGender(String selectedGender) {
    final currentYear = DateTime.now().year;
    final minAge = minAgeGender[selectedGender.toLowerCase()] ?? 0;
    return List.generate(50, (index) => (currentYear - index).toString()).where(
      (year) {
        final age = currentYear - int.parse(year);
        return age >= minAge;
      },
    ).toList();
  }

  List<String> getAvailableMonths() {
    return List.generate(12, (index) => (index + 1).toString());
  }

  void _onUpdateGenderEvent(UpdateGenderEvent event, Emitter<ForumState> emit) {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      final updatedFields = Map<String, String>.from(currentState.fields);
      final selectedGender = event.selectId ?? '';
      updatedFields[event.feildId!] = event.selectId ?? '';
      final updateYaer = getYearBasedOnGender(selectedGender);
      emit(
        currentState.copyWith(
          fields: updatedFields,
          selectedGender: selectedGender,
          yearOptions: updateYaer,
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
          formElements: elements,
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
}
