import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Instantiating aa new uuid object
const uniqueID = Uuid();

// Creating an enum to support the different types of categories
enum Category {
  food,
  travel,
  leisure,
  work,
  entertainment,
}

//Creating a map of icons used to identify the category of the expense
Map<Category, IconData> categoryIcons = {
  Category.food: Icons.fastfood,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.sentiment_satisfied_sharp,
  Category.work: Icons.work_history_rounded,
  Category.entertainment: Icons.movie
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uniqueID.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get dateFormatter{
    return '${date.year}-${date.month}-${date.day}';
  }
}
