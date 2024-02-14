import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expenses.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    Key? key,
    required this.onAddExpense,
  }) : super(key: key);

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  //Initialising the text editing controllers
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
  }

  //Implementing the date picker in my application
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month - 1, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  //Formatting the date time object to more human readable file
  String get selectedDate {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${_selectedDate!.day}, ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';
  }

  //Disposing a controllers after use so as not to make the system crash after a while
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submittedExpenseData() {
    //Converting the amount controller to an integer
    final enteredAmount = double.tryParse(_amountController.text);
    //Validating the entered amount
    final bool amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    //Validating the title controller
    final bool titleIsEmpty = _titleController.text.trim().isEmpty;

    if (amountIsInvalid && !titleIsEmpty && !(_selectedDate == null)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid amount'),
          content: const Text('You entered the wrong amount'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Retry'),
            )
          ],
        ),
      );
      return;
    }
    if (titleIsEmpty && !amountIsInvalid && !(_selectedDate == null)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid title'),
          content: const Text('Please input a title'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Retry'),
            )
          ],
        ),
      );
      return;
    }
    if (_selectedDate == null && !titleIsEmpty && !amountIsInvalid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Date missing'),
          content: const Text('Please select a date'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _presentDatePicker();
              },
              child: const Text('select'),
            )
          ],
        ),
      );
      return;
    }
    if (_selectedDate == null || titleIsEmpty || amountIsInvalid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input!'),
          content: const Text('Try inputting the right data'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Retry'),
            )
          ],
        ),
      );
      return;
    }

    //Saving data from the user
    final newExpense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );//My additional function

    widget.onAddExpense(
      newExpense,
    );
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.phone,
                  controller: _amountController,
                  decoration: const InputDecoration(
                    prefixText: 'Ksh.',
                    label: Text('Amount'),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_selectedDate == null
                        ? 'No selected date'
                        : selectedDate),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month_outlined),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name[0].toUpperCase() +
                              category.name.substring(1),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submittedExpenseData,
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
