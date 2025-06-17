import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/widget/build_form.dart';

class FormPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FormPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Form"),
        actions: [
          MaterialButton(
            child: Text("Print"),
            onPressed: () {
              context.read<FormBloc>().printFormData();
            },
          ),
        ],
      ),
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
