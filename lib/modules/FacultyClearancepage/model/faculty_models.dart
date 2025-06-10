enum StepState { pending, approved, rejected }

class ClearanceStep {
  final String label;
  final StepState state;
  final String? note; // For rejection reason

  const ClearanceStep(this.label, this.state, {this.note});
}
