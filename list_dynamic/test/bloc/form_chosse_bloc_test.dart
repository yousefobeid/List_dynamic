import 'package:bloc_test/bloc_test.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_event.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../helper/mocks.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
  });
  group('FormChosseBloc ', () {
    blocTest<FormChosseBloc, FormChosseState>(
      'emits FormChoiceLoading then FormChoiceLoded on CheckLocalData event with empty data',
      build: () {
        when(mockDatabaseHelper.getAllData()).thenAnswer((_) async => []);
        return FormChosseBloc(mockDatabaseHelper);
      },
      seed: () => FormChoiceInitail(),
      act: (bloc) => bloc.add(CheckLocalData()),
      expect:
          () => [
            isA<FormChoiceLoading>(),
            isA<FormChoiceLoded>().having(
              (state) => state.localData,
              'data',
              [],
            ),
          ],
    );
    blocTest(
      'toggles item expansion when index is not in expandedMore',
      build: () {
        when(mockDatabaseHelper.getAllData()).thenAnswer((_) async => []);
        return FormChosseBloc(mockDatabaseHelper);
      },
      seed: () => FormChoiceLoded([], expandedMore: {}),
      act: (bloc) => bloc.add(ToggleItemExpansionEvent(1)),
      expect:
          () => [
            // isA<FormChoiceInitail>(),
            isA<FormChoiceLoded>().having(
              (state) => state.expandedMore,
              'expandedMore',
              {1},
            ),
          ],
    );
  });
}
