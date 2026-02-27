class Expense {
  final String id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;
  final String phase; // 'planting' or 'harvest'

  Expense({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.phase,
  });

  factory Expense.empty() {
    return Expense(
      id: '',
      category: 'Seeds',
      description: '',
      amount: 0,
      date: DateTime.now(),
      phase: 'planting',
    );
  }

  Expense copyWith({
    String? id,
    String? category,
    String? description,
    double? amount,
    DateTime? date,
    String? phase,
  }) {
    return Expense(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      phase: phase ?? this.phase,
    );
  }
}

class ProfitLossData {
  final List<Expense> expenses;
  final double revenue;
  final String cropType;
  final DateTime plantingDate;
  final DateTime harvestDate;

  ProfitLossData({
    required this.expenses,
    required this.revenue,
    required this.cropType,
    required this.plantingDate,
    required this.harvestDate,
  });

  double get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);

  double get profit => revenue - totalExpenses;

  double get profitMargin => totalExpenses > 0 ? (profit / revenue * 100) : 0;

  Map<String, double> get expensesByCategory {
    final Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] = (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  Map<String, double> get expensesByPhase {
    final Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.phase] = (result[expense.phase] ?? 0) + expense.amount;
    }
    return result;
  }
}
