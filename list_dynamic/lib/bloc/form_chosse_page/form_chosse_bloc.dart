import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_event.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_state.dart';
import 'package:list_dynamic/core/service/database_helper.dart';

class FormChosseBloc extends Bloc<FormChosseEvent, FormChosseState> {
  DatabaseHelper databaseHelper;
  FormChosseBloc(this.databaseHelper) : super(FormChoiceInitail()) {
    on<CheckLocalData>(_loadLocalData);
    on<ToggleItemExpansionEvent>(_toggleItemExpansion);
  }

  Future<void> _loadLocalData(
    CheckLocalData event,
    Emitter<FormChosseState> emit,
  ) async {
    emit(FormChoiceLoading());
    try {
      final data = await databaseHelper.getAllData();
      emit(FormChoiceLoded(data, expandedMore: {}));
    } catch (e) {}
  }

  void _toggleItemExpansion(
    ToggleItemExpansionEvent event,
    Emitter<FormChosseState> emit,
  ) {
    final currentState = state;
    if (currentState is FormChoiceLoded) {
      final expandedSet = Set<int>.from(currentState.expandedMore);

      if (expandedSet.contains(event.index)) {
        expandedSet.remove(event.index);
      } else {
        expandedSet.add(event.index);
      }

      emit(currentState.copyWith(expandedMore: expandedSet));
    }
  }
}
