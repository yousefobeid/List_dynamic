import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_bloc.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_event.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_state.dart';

class PageViewInformation extends StatelessWidget {
  const PageViewInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Form Data")),
      body: BlocBuilder<FormChosseBloc, FormChosseState>(
        builder: (context, state) {
          if (state is FormChoiceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FormChoiceLoded) {
            final data = state.localData;
            final expandedSet = state.expandedMore;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final isExpanded = expandedSet.contains(index);

                final firstName = item['firstName'] ?? '';
                final lastName = item['lastName'] ?? '';

                final otherFields = item.entries.where(
                  (entry) =>
                      entry.key != 'firstName' &&
                      entry.key != 'lastName' &&
                      entry.key != 'id' &&
                      entry.key != 'isSynced' &&
                      entry.key != 'idFirebase' &&
                      entry.value != null,
                );

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Name: $firstName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last Name: $lastName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () {
                            context.read<FormChosseBloc>().add(
                              ToggleItemExpansionEvent(index),
                            );
                          },
                          child: Text(
                            isExpanded ? 'Less ▲' : 'More ▼',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        if (isExpanded) ...[
                          const Divider(height: 24),
                          ...otherFields.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.value.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Something went wrong or no data."));
        },
      ),
    );
  }
}
