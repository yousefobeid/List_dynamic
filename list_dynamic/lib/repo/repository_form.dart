import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:list_dynamic/data/local/database_helper.dart';
import 'package:list_dynamic/model/form_element_model.dart';
import 'package:list_dynamic/service/network_service.dart';

class FormRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NetworkService _networkService = NetworkService();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
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
    await _databaseHelper.insertData(fields);
    final connected = await _networkService.isActuallyConnected();
    if (connected == true) {
      try {
        await _firestore.collection(collectionName).add(fields);
        print(" تم رفع البيانات إلى Firebase");
      } catch (e) {
        print(" فشل رفع البيانات إلى Firebase: $e");
      }
    } else {
      print(" لا يوجد اتصال بالإنترنت، تم الحفظ محليًا فقط.");
    }
  }
}
