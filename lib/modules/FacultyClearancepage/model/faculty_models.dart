enum StepState { pending, approved, rejected }

class ClearanceStep {
  final String label;
  final StepState state;
  final String? note;

  const ClearanceStep(this.label, this.state, {this.note});
}
