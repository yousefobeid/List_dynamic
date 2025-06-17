import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_event.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_state.dart';
import 'package:list_dynamic/view/screen/form_view_information.dart';
import 'package:list_dynamic/widget/custom_button.dart';
import 'package:lottie/lottie.dart';

class FormChoicePage extends StatelessWidget {
  const FormChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Form(
        key: const Key("formChoicePageKey"),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<FormChosseBloc, FormChosseState>(
              builder: (context, state) {
                if (state is FormChoiceInitail) {
                  context.read<FormChosseBloc>().add(CheckLocalData());
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/view_form.json",
                      fit: BoxFit.fill,
                      height: 200,
                    ),
                    const SizedBox(height: 40),

                    if (state is FormChoiceLoading)
                      const CircularProgressIndicator(color: Colors.blue),

                    if (state is FormChoiceLoded &&
                        state.localData.isNotEmpty) ...[
                      CustomButton(
                        key: const Key("chooseButton_view"),
                        label: "View Information",
                        icon: Icons.list,
                        onPressed: () {
                          context.read<FormChosseBloc>().add(CheckLocalData());
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PageViewInformation(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        key: const Key("chooseButton_move"),
                        label: "Move To The Form",
                        icon: Icons.edit_note,
                        onPressed: () {
                          Navigator.of(context).pushNamed("/formPage");
                        },
                      ),
                    ],

                    if (state is FormChoiceLoded && state.localData.isEmpty)
                      CustomButton(
                        key: const Key("chooseButton_go"),
                        label: "Go To The Form",
                        icon: Icons.edit_note,
                        onPressed: () {
                          Navigator.of(context).pushNamed("/formPage");
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
