import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/repo/repository_form.dart';
import 'package:list_dynamic/widget/build_review_form.dart';

// ignore: must_be_immutable
class FormReviewPage extends StatelessWidget {
  FormRepository formRepository = FormRepository();
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

                      final value = state.fields[element.id];
                      return value != null && value.trim().isNotEmpty;
                    })
                    .map((element) {
                      String value;

                      if (element.type == 'date_picker') {
                        value =
                            '${state.selectedDay}-${state.selectedMonth}-${state.selectedYear}';
                      } else {
                        value = state.fields[element.id]!;
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
                      final Map<String, String> formData = Map.from(
                        state.fields,
                      );
                      if (state.selectedYear != null &&
                          state.selectedMonth != null &&
                          state.selectedDay != null) {
                        final birthdate =
                            '${state.selectedDay}-${state.selectedMonth}-${state.selectedYear}';
                        formData['birthdate'] = birthdate;
                      }
                      await formRepository.submitFormData(formData);
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
