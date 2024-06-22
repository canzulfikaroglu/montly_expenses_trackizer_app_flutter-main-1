List<Map<String, dynamic>> expenses = [];

void _addExpense(String name, double price, DateTime date) {
  expenses.add({"name": name, "price": price, "date": date});
}
