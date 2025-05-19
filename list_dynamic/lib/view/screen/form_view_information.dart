import 'package:flutter/material.dart';

class PageViewInformation extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PageViewInformation({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Form Data")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

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
                children:
                    item.entries
                        .where(
                          (entry) =>
                              entry.key != "id" &&
                              entry.key != "isSynced" &&
                              entry.value != null,
                        )
                        .map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        })
                        .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
