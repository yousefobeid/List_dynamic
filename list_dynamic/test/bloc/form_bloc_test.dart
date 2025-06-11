import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/core/service/database_helper.dart';
import 'package:list_dynamic/model/form_element_model.dart';
import 'package:list_dynamic/model/form_model.dart';
import 'package:list_dynamic/model/form_rule_model.dart';
import 'package:mockito/mockito.dart';

import '../helper/mocks.mocks.dart';

void main() {
  late MockIInternetCheck mockIInternetCheck;
  late MockFormRepository mockFormRepository;
  late FormModel emptyFormModel;
  late FormModel populatedFormModel;
  late DatabaseHelper databaseHelper;
  late FormBloc formBloc;

  setUp(() {
    mockIInternetCheck = MockIInternetCheck();
    when(mockIInternetCheck.hasInternet()).thenAnswer((_) async => true);
    mockFormRepository = MockFormRepository();
    emptyFormModel = FormModel(elements: [], rules: []);
    databaseHelper = DatabaseHelper.instance;
    populatedFormModel = FormModel(
      elements: [
        FormElementModel(
          id: '1',
          key: 'name',
          type: 'textField',
          label: 'Name',
          hint: 'yousef',
          isRequired: true,
        ),
        FormElementModel(
          id: '2',
          key: 'gender',
          type: 'radio',
          label: 'gender',
          choose: [
            Choose(label: 'Male', value: 'male'),
            Choose(label: 'Female', value: 'female'),
          ],
          isRequired: true,
        ),
      ],
      rules: [
        FormRuleModel(
          condition: {'field': 'country', 'equals': 'YE'},
          action: {'show': 'city'},
        ),
      ],
    );
    formBloc = FormBloc(mockFormRepository, databaseHelper, populatedFormModel);
  });

  test('initial state is FormInitial', () {
    expect(formBloc.state, FormInitial());
  });

  group('FormBloc', () {
    blocTest<FormBloc, ForumState>(
      'emits updated with UpdateBirthDateEvent',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => emptyFormModel);
        return FormBloc(mockFormRepository, databaseHelper, emptyFormModel);
      },
      seed:
          () => FormLoaded(
            formElements: [],
            rule: [],
            availableYears: ['2024'],
            availableMonths: ['1'],
            availableDays: [],
            fields: {},
            requiredFields: [],
            optionalFields: [],
          ),
      act:
          (bloc) => bloc.add(
            UpdateBirthDateEvent(year: '2024', month: '1', day: '1'),
          ),
      expect:
          () => [
            isA<FormLoaded>()
                .having((state) => state.selectedYear, 'selectedYear', '2024')
                .having((state) => state.selectedMonth, 'selectedMonth', '1')
                .having((state) => state.selectedDay, 'selectedDay', '1')
                .having(
                  (state) => state.availableDays.length,
                  'availableDays',
                  31,
                ),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'Validate emit on the internet check',
      build: () {
        when(mockIInternetCheck.hasInternet()).thenAnswer((_) async => true);
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => populatedFormModel);
        return FormBloc(mockFormRepository, databaseHelper, populatedFormModel);
      },
      act: (bloc) => bloc.add(ResetFormEvent()),
      expect: () => [isA<FormLoading>(), isA<FormLoaded>()],
    );
    blocTest<FormBloc, ForumState>(
      'Validate emit on the No internet check',
      build: () {
        when(mockIInternetCheck.hasInternet()).thenAnswer((_) async => false);
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => populatedFormModel);
        return FormBloc(mockFormRepository, databaseHelper, populatedFormModel);
      },
      act: (bloc) => bloc.add(ResetFormEvent()),
      expect: () => [isA<FormLoading>(), isA<FormLoaded>()],
    );
    blocTest<FormBloc, ForumState>(
      'emits updated with ResetFormEvent',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => populatedFormModel);

        return FormBloc(mockFormRepository, databaseHelper, populatedFormModel);
      },

      seed:
          () => FormLoaded(
            formElements: [],
            rule: [],
            availableYears: [],
            availableMonths: [],
            availableDays: [],
            fields: {'someField': 'someValue'},
            requiredFields: [],
            optionalFields: [],
          ),
      act: (bloc) => bloc.add(ResetFormEvent()),
      expect:
          () => [
            isA<FormLoading>(),
            isA<FormLoaded>().having((state) => state.fields, 'fields', {}),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'emits updated with ToggleOptionEvent',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => emptyFormModel);
        return FormBloc(mockFormRepository, databaseHelper, emptyFormModel);
      },
      seed:
          () => FormLoaded(
            formElements: [],
            rule: [],
            availableYears: [],
            availableMonths: [],
            availableDays: [],
            fields: {},
            requiredFields: [],
            optionalFields: [],
          ),
      act: (bloc) => bloc.add(ToggleOptionEvent(showOption: true)),
      expect:
          () => [
            isA<FormLoaded>().having(
              (state) => state.isOptionEnabled,
              'isOptionEnabled',
              true,
            ),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'emits updated with UpdateGenderEvent',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => emptyFormModel);
        return FormBloc(mockFormRepository, databaseHelper, emptyFormModel);
      },
      seed:
          () => FormLoaded(
            fields: {},
            formElements: [],
            rule: [],
            selectedYear: null,
            selectedMonth: null,
            selectedDay: null,
            religion: "male",
            isOptionEnabled: false,
            requiredFields: [],
            optionalFields: [],
            availableDays: [],
            availableMonths: [],
            availableYears: [],
          ),

      act:
          (bloc) =>
              bloc.add(UpdateGenderEvent(feildId: 'gender', selectId: 'male')),
      expect:
          () => [
            isA<FormLoaded>().having(
              (state) => state.selectedGender,
              'selectedGender',
              'male',
            ),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'emits updated fields when UpdateEvent is added',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => populatedFormModel);
        return FormBloc(mockFormRepository, databaseHelper, populatedFormModel);
      },
      seed:
          () => FormLoaded(
            fields: {'name': 'OldValue'},
            formElements: [],
            rule: [],
            selectedYear: null,
            selectedMonth: null,
            selectedDay: null,
            religion: null,
            isOptionEnabled: false,
            requiredFields: [],
            optionalFields: [],
            availableDays: [],
            availableMonths: [],
            availableYears: [],
          ),
      act: (bloc) => bloc.add(UpdateEvent(id: 'name', value: 'NewValue')),
      expect:
          () => [
            isA<FormLoaded>().having(
              (state) => state.fields['name'],
              'name field',
              'NewValue',
            ),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'emits [FormLoading, FormLoaded] with empty data when fetch is successful',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => emptyFormModel);
        return FormBloc(mockFormRepository, databaseHelper, emptyFormModel);
      },
      act: (bloc) => bloc.add(LoadFormDataEvent()),
      expect:
          () => [
            isA<FormLoading>(),
            isA<FormLoaded>()
                .having((state) => state.fields, 'fields', {})
                .having((state) => state.formElements, 'formElements', [])
                .having((state) => state.rule, 'rule', []),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'emits [FormLoading, FormLoaded] with populated data when fetch is successful',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => populatedFormModel);
        return FormBloc(mockFormRepository, databaseHelper, populatedFormModel);
      },
      act: (bloc) => bloc.add(LoadFormDataEvent()),
      expect:
          () => [
            isA<FormLoading>(),
            isA<FormLoaded>()
                .having(
                  (state) => state.formElements.length,
                  'formElements length',
                  2,
                )
                .having((state) => state.rule.length, 'rule length', 1),
          ],
    );
    blocTest<FormBloc, ForumState>(
      'emits [FormLoading, FormLoaded] when LoadFormDataEvent is added',
      build: () {
        when(
          mockFormRepository.fetchFormData(),
        ).thenAnswer((_) async => emptyFormModel);
        return FormBloc(mockFormRepository, databaseHelper, emptyFormModel);
      },
      act: (bloc) => bloc.add(LoadFormDataEvent()),
      expect: () => [isA<FormLoading>(), isA<FormLoaded>()],
    );
  });

  group('FormRepository Test', () {
    test('fetchFormData returns empty FormModel', () async {
      when(
        (mockFormRepository.fetchFormData()),
      ).thenAnswer((_) async => emptyFormModel);
      final result = await mockFormRepository.fetchFormData();
      expect(result.elements, isEmpty);
      expect(result.rules, isEmpty);
    });
    test('fetchFormData returns populated FormModel', () async {
      when(
        mockFormRepository.fetchFormData(),
      ).thenAnswer((_) async => populatedFormModel);
      final result = await mockFormRepository.fetchFormData();
      expect(result.elements.length, 2);
      expect(result.elements[0].label, 'Name');
      expect(result.elements[1].type, 'radio');
      expect(result.rules.first.condition['equals'], 'YE');
    });
    test('fetchFormData handles unknown element types gracefully', () async {
      final formModelWithUnknownType = FormModel(
        elements: [
          FormElementModel(
            id: '4',
            key: 'custom',
            type: 'customType',
            label: 'Custom Element',
            isRequired: false,
          ),
        ],
        rules: [],
      );

      when(
        mockFormRepository.fetchFormData(),
      ).thenAnswer((_) async => formModelWithUnknownType);

      final result = await mockFormRepository.fetchFormData();

      expect(result.elements.length, 1);
      expect(result.elements[0].type, 'customType');
    });
    test('submitFormData returns true when submission succeeds', () async {
      final testData = {'name': 'Ahmed', 'gender': 'male'};
      when(
        mockFormRepository.submitFormData(any),
      ).thenAnswer((_) async => true);
      await mockFormRepository.submitFormData(testData);
      verify(mockFormRepository.submitFormData(testData)).called(1);
    });
    test('submitFormData throws exception on error', () async {
      final testData = {'name': 'Ahmed', 'gender': 'male'};

      when(
        mockFormRepository.submitFormData(any),
      ).thenThrow(Exception('Network error'));

      expect(
        () => mockFormRepository.submitFormData(testData),
        throwsException,
      );
    });
  });
}
