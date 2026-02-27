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

class FarmingProject {
  final String id;
  final String cropType;
  final double area;
  final DateTime plantingDate;
  final DateTime harvestDate;
  final double revenue;
  final List<Expense> expenses;
  final DateTime createdDate;
  final String status; // 'active', 'completed'

  FarmingProject({
    required this.id,
    required this.cropType,
    required this.area,
    required this.plantingDate,
    required this.harvestDate,
    required this.revenue,
    required this.expenses,
    required this.createdDate,
    required this.status,
  });

  double get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);
  double get profit => revenue - totalExpenses;
  double get profitMargin => revenue > 0 ? (profit / revenue * 100) : 0;

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

  FarmingProject copyWith({
    String? id,
    String? cropType,
    double? area,
    DateTime? plantingDate,
    DateTime? harvestDate,
    double? revenue,
    List<Expense>? expenses,
    DateTime? createdDate,
    String? status,
  }) {
    return FarmingProject(
      id: id ?? this.id,
      cropType: cropType ?? this.cropType,
      area: area ?? this.area,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      revenue: revenue ?? this.revenue,
      expenses: expenses ?? this.expenses,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
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
