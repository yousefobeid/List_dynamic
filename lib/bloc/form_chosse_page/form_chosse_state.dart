abstract class FormChosseState {}

class FormChoiceInitail extends FormChosseState {}

class FormChoiceLoading extends FormChosseState {}

class FormChoiceLoded extends FormChosseState {
  final List<Map<String, dynamic>> localData;
  final Set<int> expandedMore;
  FormChoiceLoded(this.localData, {this.expandedMore = const {}});
  FormChoiceLoded copyWith({Set<int>? expandedMore}) {
    return FormChoiceLoded(
      localData,
      expandedMore: expandedMore ?? this.expandedMore,
    );
  }
}
