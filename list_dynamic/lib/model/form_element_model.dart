class FormElementModel {
  final String id;
  final String? type;
  final String? label;
  final String? hint;
  final List<Choose>? choose;
  final BirthDateOptions? chooseBirthDate;
  final bool? required;
  final int? maxLength;
  final String? keyboardType;
  FormElementModel({
    required this.id,
    this.type,
    this.label,
    this.hint,
    this.choose,
    this.chooseBirthDate,
    this.required,
    this.maxLength,
    this.keyboardType,
  });
  //create a Dart object from JSON data.
  factory FormElementModel.fromJson(Map<String, dynamic> json) {
    final String? elementType = json['type'];

    List<Choose>? chooseList;
    BirthDateOptions? birthDateOptions;

    if (elementType == 'radio' || elementType == 'dropdown') {
      if (json['choose'] != null && json['choose'] is List) {
        chooseList = List<Choose>.from(
          json['choose'].map((item) => Choose.fromJson(item)),
        );
      }
    } else if (elementType == 'date_picker') {
      if (json['choose'] != null && json['choose'] is Map) {
        birthDateOptions = BirthDateOptions.fromJson(json['choose']);
      }
    }

    return FormElementModel(
      id: json['id'] ?? '',
      type: elementType,
      label: json['label'],
      hint: json['hint'],
      choose: chooseList,
      chooseBirthDate: birthDateOptions,
      required: json['required'],
      maxLength: json['maxLength'],
      keyboardType: json['keyboardType'],
    );
  }
}

class Choose {
  final String label;
  final String value;

  Choose({required this.label, required this.value});

  factory Choose.fromJson(Map<String, dynamic> json) {
    return Choose(label: json['label'] ?? '', value: json['value'] ?? '');
  }
}

class BirthDateOptions {
  final List<String> years;
  final List<Map<String, String>> months;

  BirthDateOptions({required this.years, required this.months});

  factory BirthDateOptions.fromJson(Map<String, dynamic> json) {
    return BirthDateOptions(
      years: List<String>.from(json['years'] ?? []),
      months:
          (json['months'] as List<dynamic>?)?.map((item) {
            if (item is Map<String, dynamic>) {
              return {
                'label': item['label']?.toString() ?? '',
                'value': item['value']?.toString() ?? '',
              };
            } else {
              return {'label': '', 'value': ''};
            }
          }).toList() ??
          [],
    );
  }
}
