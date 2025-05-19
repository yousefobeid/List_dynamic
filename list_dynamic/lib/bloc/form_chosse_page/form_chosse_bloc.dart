import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_event.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_state.dart';
import 'package:list_dynamic/data/local/database_helper.dart';

class FormChosseBloc extends Bloc<FormChosseEvent, FormChosseState> {
  DatabaseHelper databaseHelper;
  FormChosseBloc(this.databaseHelper) : super(FormChoiceInitail()) {
    on<CheckLocalData>(_loadLocalData);
  }

  Future<void> _loadLocalData(
    CheckLocalData event,
    Emitter<FormChosseState> emit,
  ) async {
    emit(FormChoiceLoading());

    try {
      final data = await databaseHelper.getAllData();
      emit(FormChoiceLoded(data));
    } catch (e) {
      print("=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $e");
    }
  }
}
