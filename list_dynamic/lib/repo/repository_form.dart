import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:list_dynamic/core/helpers/internet_chek.dart';
import 'package:list_dynamic/core/service/database_helper.dart';
import 'package:list_dynamic/model/form_element_model.dart';
import 'package:list_dynamic/model/form_model.dart';
import 'package:list_dynamic/model/form_rule_model.dart';
import 'package:uuid/uuid.dart';

class FormRepository {
  final FormModel formModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  FormRepository({required this.formModel});
  Future<FormModel> fetchFormData() async {
    await Future.delayed(Duration(seconds: 2));
    final String response = await rootBundle.loadString('assets/form.json');
    final data = json.decode(response);

    final List<dynamic> elements = data['formElements'];
    List<FormElementModel> formElements =
        elements.map((item) => FormElementModel.fromJson(item)).toList();
    final List<FormRuleModel> rules =
        (data['rule'] as List<dynamic>?)
            ?.map((item) => FormRuleModel.fromJson(item))
            .toList() ??
        [];

    return FormModel(elements: formElements, rules: rules);
  }

  Future<void> submitFormData(
    Map<String, dynamic> fields, {
    String collectionName = 'submittedForms',
  }) async {
    await _databaseHelper.insertData(fields);
    final connected = await InternetCheck.hasInternet();
    if (connected == true) {
      try {
        final idFirebase = fields['idFirebase'] ?? Uuid().v4();
        await _firestore.collection(collectionName).doc(idFirebase).set(fields);
        print(" تم رفع البيانات إلى Firebase");
      } catch (e) {
        print(" فشل رفع البيانات إلى Firebase: $e");
      }
    } else {
      print(" لا يوجد اتصال بالإنترنت، تم الحفظ محليًا فقط.");
    }
  }
}
