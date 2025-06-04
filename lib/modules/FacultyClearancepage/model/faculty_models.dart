enum StepState { pending, approved, rejected }

class ClearanceStep {
  final String label;
  final StepState state;
  const ClearanceStep(this.label, this.state);

  bool get isApproved => state == StepState.approved;
}
