enum HabitDetailAction { toggleCompletion, edit }

class HabitDetailResult {
  final String habitId;
  final HabitDetailAction action;

  const HabitDetailResult({required this.habitId, required this.action});
}
