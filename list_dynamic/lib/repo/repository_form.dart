import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:list_dynamic/model/form_element_model.dart';

class FormRepository {
  Future<List<FormElementModel>> fetchFormData() async {
    await Future.delayed(Duration(seconds: 2));
    final String response = await rootBundle.loadString('assets/form.json');
    final data = json.decode(response);
    final List<dynamic> elements = data['formElements'];
    List<FormElementModel> formElements =
        elements.map((item) => FormElementModel.fromJson(item)).toList();
    return formElements;
  }

  Future<void> submitFormData(
    Map<String, String> fields, {
    String collectionName = 'submittedForms',
  }) async {
    try {
      await FirebaseFirestore.instance.collection(collectionName).add(fields);
    } catch (e) {
      print(" فشل إرسال البيانات: $e");
    }
  }
}
