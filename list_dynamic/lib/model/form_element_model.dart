class FormElementModel {
  final String id;
  final String? type;
  final String? label;
  final String? hint;
  final List<Choose>? choose;
  final bool isRequired;
  final bool isOption;
  final String key;
  final List<String>? dependsOn;
  final String? expressionKey;
  final String? action;
  FormElementModel({
    required this.id,
    this.type,
    this.label,
    this.hint,
    this.choose,
    this.isRequired = false,
    this.isOption = false,
    required this.key,
    this.action,
    this.dependsOn,
    this.expressionKey,
  });
  //create a Dart object from JSON data.
  factory FormElementModel.fromJson(Map<String, dynamic> json) {
    final String? elementType = json['type'];
    List<Choose>? chooseList;
    if (elementType == 'radio' || elementType == 'dropdown') {
      if (json['choose'] != null && json['choose'] is List) {
        chooseList = List<Choose>.from(
          json['choose'].map((item) => Choose.fromJson(item)),
        );
      }
    }
    return FormElementModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      type: elementType,
      label: json['label'] ?? '',
      hint: json['hint'] ?? '',
      choose: chooseList,
      isRequired: json['required'] ?? false,
      isOption: json['option'] ?? false,
      dependsOn:
          json['dependsOn'] != null
              ? List<String>.from(json["dependsOn"])
              : null,
      expressionKey: json['expressionKey'],
      action: json['action'],
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
