abstract class FormChosseState {}

class FormChoiceInitail extends FormChosseState {}

class FormChoiceLoading extends FormChosseState {}

class FormChoiceLoded extends FormChosseState {
  final List<Map<String, dynamic>> localData;
  FormChoiceLoded(this.localData);
}
