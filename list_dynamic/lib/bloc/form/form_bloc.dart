import 'package:bloc/bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/repo/repository_form.dart';

class FormBloc extends Bloc<FormEvent, ForumState> {
  final FormRepository formRepository;
  Map<String, String> textValues = {};

  FormBloc(this.formRepository) : super(FormInitial()) {
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
        fields: textValues,
        formElements: formElements,
        selectedYear: null,
        selectedMonth: null,
        selectedDay: null,
        religion: null,
        isOptionEnabled: false,
        requiredFields: requiredFields,
        optionalFields: optionalFields,
      ),
    );
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<ForumState> emit) {
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
      final int year = int.tryParse(event.year) ?? DateTime.now().year;
      final int month = int.tryParse(event.month) ?? 1;
      List<String> generateDays(int year, int month) {
        final lastDay = DateTime(year, month + 1, 0).day;
        return List.generate(lastDay, (i) => (i + 1).toString());
      }

      final updatedDays = generateDays(year, month);
      emit(
        (state as FormLoaded).copyWith(
          selectedYear: event.year,
          selectedMonth: event.month,
          selectedDay: event.day,
          days: updatedDays,
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
      final elements = await FormRepository().fetchFormData();
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

  void _onUpdateGenderEvent(UpdateGenderEvent event, Emitter<ForumState> emit) {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      final updatedFields = Map<String, String>.from(currentState.fields);
      updatedFields[event.feildId!] = event.selectId ?? '';
      emit(currentState.copyWith(fields: updatedFields));

      emit(currentState.copyWith(selectedGender: event.selectId));
    }
  }
}
