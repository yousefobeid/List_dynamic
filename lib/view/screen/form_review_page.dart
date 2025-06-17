import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_event.dart';
import 'package:list_dynamic/model/form_model.dart';
import 'package:list_dynamic/repo/repository_form.dart';
import 'package:list_dynamic/widget/build_review_form.dart';

// ignore: must_be_immutable
class FormReviewPage extends StatelessWidget {
  FormRepository formRepository = FormRepository(
    formModel: FormModel(rules: [], elements: []),
  );
  FormReviewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data review')),
      body: BlocBuilder<FormBloc, ForumState>(
        builder: (context, state) {
          if (state is FormLoaded) {
            return ListView(
              children: [
                ...state.formElements
                    .where((element) {
                      if (element.type == 'date_picker') {
                        return state.selectedYear != null &&
                            state.selectedMonth != null &&
                            state.selectedDay != null;
                      }
                      final value = state.fields[element.key];
                      return value != null && value.trim().isNotEmpty;
                      // final value = state.fields[element.id];
                      // return value != null && value.trim().isNotEmpty;
                    })
                    .map((element) {
                      String value;

                      if (element.type == 'date_picker') {
                        value =
                            '${state.selectedDay}-${state.selectedMonth}-${state.selectedYear}';
                      } else {
                        value = state.fields[element.key]!;
                      }

                      return buildReviewItem(
                        title: element.label!,
                        value: value,
                      );
                    }),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final Map<String, dynamic> formData = {};
                      for (final element in state.formElements) {
                        final key = element.key;
                        // final id = element.id.toString();
                        final value = state.fields[element.key];
                        if (value != null && value.trim().isNotEmpty) {
                          formData[key] = value;
                        }
                      }
                      if (state.selectedYear != null &&
                          state.selectedMonth != null &&
                          state.selectedDay != null) {
                        final birthdate =
                            '${state.selectedDay}-${state.selectedMonth}-${state.selectedYear}';
                        formData['birthdate'] = birthdate;
                      }
                      await formRepository.submitFormData(formData);
                      context.read<FormChosseBloc>().add(CheckLocalData());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              "The process was completed successfully",
                            ),
                          ),
                        );
                      }
                      context.read<FormBloc>().add(ResetFormEvent());
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
