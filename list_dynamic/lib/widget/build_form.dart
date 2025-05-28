import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form/form_state.dart';
import 'package:list_dynamic/model/form_element_model.dart';

Widget buildFormField(
  GlobalKey<FormState> formKey,
  FormElementModel element,
  BuildContext context,
  FormLoaded state, {
  bool isReadOnly = false,
}) {
  if (element.isOption == true && !state.isOptionEnabled) {
    return const SizedBox.shrink();
  }
  if (element.type == 'switch') {
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
          validator: (value) {
            if (!isReadOnly &&
                (value == null || value.isEmpty) &&
                element.isRequired == true) {
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
                      UpdateEvent(id: element.key, value: value),
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
            Row(
              children: [
                Text(
                  element.label ?? 'الجنس',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 15),
                if ((state.vaildationError?[element.key]) != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      state.vaildationError![element.key] ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...element.choose!.map((option) {
                  return RadioListTile<String>(
                    title: Text(option.label),
                    value: option.value,
                    groupValue: state.fields[element.key],
                    onChanged:
                        isReadOnly
                            ? null
                            : (value) {
                              context.read<FormBloc>().add(
                                UpdateGenderEvent(
                                  feildId: element.id,
                                  selectId: value,
                                ),
                              );
                            },
                  );
                }),
              ],
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
            if (!isReadOnly &&
                (value == null || value.isEmpty) &&
                element.isRequired == true) {
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
                      UpdateEvent(id: element.key, value: value ?? ''),
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
              element.label ?? 'Brith Date',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (!state.isOptionEnabled && value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    value:
                        state.selectedYear != null &&
                                state.availableYears.contains(
                                  state.selectedYear,
                                )
                            ? state.selectedYear
                            : null,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        state.availableYears
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ),
                            )
                            .toList(),
                    onChanged:
                        isReadOnly
                            ? null
                            : (value) {
                              context.read<FormBloc>().add(
                                UpdateBirthDateEvent(
                                  year: value ?? '',
                                  month: state.selectedMonth ?? '',
                                  day: state.selectedDay ?? '',
                                ),
                              );
                            },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (!state.isOptionEnabled && value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    value:
                        context.read<FormBloc>().getAvailableMonths().contains(
                              state.selectedMonth ?? '',
                            )
                            ? state.selectedMonth
                            : null,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        context
                            .read<FormBloc>()
                            .getAvailableMonths()
                            .map(
                              (month) => DropdownMenuItem(
                                value: month,
                                child: Text(month),
                              ),
                            )
                            .toList(),
                    onChanged:
                        isReadOnly
                            ? null
                            : (value) {
                              context.read<FormBloc>().add(
                                UpdateBirthDateEvent(
                                  month: value ?? '',
                                  day: state.selectedDay ?? '',
                                  year: state.selectedYear ?? '',
                                ),
                              );
                            },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (!state.isOptionEnabled && value == null) {
                        return "This field is required";
                      }
                      return null;
                    },

                    value:
                        state.selectedDay != null &&
                                state.availableDays.contains(state.selectedDay)
                            ? state.selectedDay
                            : null,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        state.availableDays
                            .map(
                              (day) => DropdownMenuItem(
                                value: day,
                                child: Text(day),
                              ),
                            )
                            .toList(),
                    onChanged:
                        isReadOnly
                            ? null
                            : (value) {
                              context.read<FormBloc>().add(
                                UpdateBirthDateEvent(
                                  day: value ?? '',
                                  month: state.selectedMonth ?? '',
                                  year: state.selectedYear ?? '',
                                ),
                              );
                            },
                  ),
                ),
              ],
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
              } else {
                context.read<FormBloc>().add(ValidateFormEvent());
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
