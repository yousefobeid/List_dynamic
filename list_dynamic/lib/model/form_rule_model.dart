class FormRuleModel {
  final Map<String, dynamic> condition;
  final Map<String, dynamic> action;

  FormRuleModel({required this.condition, required this.action});

  factory FormRuleModel.fromJson(Map<String, dynamic> json) {
    return FormRuleModel(
      condition:
          json['if'] != null
              ? Map<String, dynamic>.from(json['if'])
              : <String, dynamic>{},
      action:
          json['set'] != null
              ? Map<String, dynamic>.from(json['set'])
              : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {'if': condition, 'set': action};
  }
}
