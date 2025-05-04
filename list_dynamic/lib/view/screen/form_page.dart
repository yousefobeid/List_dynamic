import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_bloc.dart';
import 'package:list_dynamic/bloc/form_state.dart';
import 'package:list_dynamic/widget/build_form.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamic Form")),
      body: BlocConsumer<FormBloc, ForumState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FormLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FormLoaded) {
            return Form(
              key: formKey,
              child: ListView.builder(
                itemCount: state.formElements.length,
                itemBuilder: (context, index) {
                  final element = state.formElements[index];
                  return buildFormField(
                    formKey,
                    element,
                    context,
                    state,
                    selectedGender,
                    isReadOnly: false,
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text("Initializing..."));
          }
        },
      ),
    );
  }
}
