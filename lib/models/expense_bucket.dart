import 'package:expense_tracker/models/expenses.dart';

class ExpenseBucket {
  final List<Expense> expenses;
  final Category category;

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
  : expenses = allExpenses.where((expense) => expense.category == category).toList();

  ExpenseBucket(
    this.expenses,
    this.category,
  );

  double get totalExpense{
    double sum = 0;

    for(final expense in expenses){
      sum += expense.amount;
    }
    return sum;
  }
}
