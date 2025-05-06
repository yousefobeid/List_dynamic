import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_bloc.dart';
import 'package:list_dynamic/bloc/form_event.dart';
import 'package:list_dynamic/bloc/form_state.dart';
import 'package:list_dynamic/model/form_element_model.dart';

ValueNotifier<String?> selectedGender = ValueNotifier(null);
GlobalKey<FormState> formKey = GlobalKey();
Widget buildFormField(
  GlobalKey<FormState> formKey,
  FormElementModel element,
  BuildContext context,
  FormLoaded state,
  ValueNotifier<String?> selectedGender, {
  bool isReadOnly = false,
}) {
  if (!state.isOptionEnabled &&
      (element.id == 'phoneNumber' || element.id == 'city')) {
    return const SizedBox.shrink();
  }
  if (element.id == 'toggleOptions') {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0, top: 20),
            child: Text(
              'Options',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text('Show additional options'),
            value: state.isOptionEnabled,
            onChanged:
                isReadOnly
                    ? null
                    : (value) {
                      context.read<FormBloc>().add(
                        ToggleOptionEvent(showOption: value),
                      );
                    },
          ),
        ],
      ),
    );
  }
  switch (element.type) {
    case 'textField':
      return Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          readOnly: isReadOnly,
          initialValue: state.fields[element.id],
          validator: (value) {
            if (!isReadOnly && (value == null || value.isEmpty)) {
              return 'This field is required';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: element.label,
            hintText: element.hint,
            border: const OutlineInputBorder(),
          ),
          onChanged:
              isReadOnly
                  ? null
                  : (value) {
                    context.read<FormBloc>().add(
                      UpdateEvent(id: element.id, value: value),
                    );
                  },
        ),
      );

    case 'radio':
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              element.label ?? 'الجنس',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: selectedGender,
              builder: (context, selectedValue, _) {
                return Column(
                  children:
                      element.choose!.map((option) {
                        return RadioListTile<String>(
                          title: Text(option.label),
                          value: option.value,
                          groupValue: selectedValue,
                          onChanged:
                              isReadOnly
                                  ? null
                                  : (value) {
                                    selectedGender.value = value;
                                    context.read<FormBloc>().add(
                                      UpdateEvent(
                                        id: element.id,
                                        value: value ?? '',
                                      ),
                                    );
                                  },
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      );

    case 'dropdown':
      return Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField<String>(
          value: state.religion,
          validator: (value) {
            if (!isReadOnly && (value == null || value.isEmpty)) {
              return 'This field is required';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: element.label ?? 'الديانة',
            border: const OutlineInputBorder(),
          ),
          items:
              element.choose?.map((option) {
                return DropdownMenuItem(
                  value: option.value,
                  child: Text(option.label),
                );
              }).toList(),
          onChanged:
              isReadOnly
                  ? null
                  : (value) {
                    context.read<FormBloc>().add(
                      UpdateEvent(id: element.id, value: value ?? ''),
                    );
                  },
        ),
      );

    case 'date_picker':
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              element.label ?? 'تاريخ الميلاد',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed:
                  isReadOnly
                      ? null
                      : () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          context.read<FormBloc>().add(
                            UpdateBirthDateEvent(
                              year: selectedDate.year.toString(),
                              month: selectedDate.month.toString(),
                              day: selectedDate.day.toString(),
                            ),
                          );
                        }
                      },
              child: Text(
                (state.selectedYear != null &&
                        state.selectedMonth != null &&
                        state.selectedDay != null)
                    ? '${state.selectedDay}-${state.selectedMonth}-${state.selectedYear}'
                    : element.label ?? 'تاريخ الميلاد',
              ),
            ),
          ],
        ),
      );

    case 'button':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (!isReadOnly) {
              formKey.currentState!.validate();
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pushNamed('/formPageReview');
              }
            }
          },
          child: Text(element.label ?? "Submit"),
        ),
      );

    default:
      return const SizedBox.shrink();
  }
}
