abstract class FormChosseEvent {}

class CheckLocalData extends FormChosseEvent {}

class ToggleItemExpansionEvent extends FormChosseEvent {
  final int index;

  ToggleItemExpansionEvent(this.index);
}
