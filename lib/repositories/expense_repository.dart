import 'package:expensetracker/collections/receipt.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../collections/expense.dart';
import '../main.dart';
import 'adapter.dart';

class BudgetRepository extends Adapter<Expense> {
  @override
  Future<void> createMultipleObjects(List<Expense> collections) async {
    await isar.writeTxn(() async {
      await isar.expenses.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Expense collection) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(collection);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await isar.expenses.deleteAll(ids);
  }

  @override
  Future<void> deleteObject(Expense collection) async {
    await isar.expenses.delete(collection.id);
  }

  @override
  Future<List<Expense>> getAllObjects() async {
    return await isar.expenses.where().findAll();
  }

  @override
  Future<Expense?> getObjectById(int id) async {
    return await isar.expenses.get(id);
  }

  @override
  Future<List<Expense?>> getObjectsById(List<int> ids) async {
    return await isar.expenses.getAll(ids);
  }

  @override
  Future<void> updateObject(Expense collection) async {
    await isar.writeTxn(() async {
      final expense = await isar.expenses.get(collection.id);
      if (expense != null) {
        await isar.expenses.put(collection);
      }
    });
  }

  Future<List<Expense>> getObjectsByToday() async {
    return await isar.expenses
        .where()
        .dateEqualTo(DateTime.now().copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0))
        .findAll();
  }

  Future<double> getSumForCategory(CategoryEnum value) async {
    return await isar.expenses.filter().categoryEqualTo(value).amountProperty().sum();
  }

  Future<List<Expense>> getObjectsByCategory(CategoryEnum value) async {
    return await isar.expenses.filter().categoryEqualTo(value).findAll();
  }

  Future<List<Expense>> getObjectsByAmountRange(double lowAmount, double highAmount) async {
    return await isar.expenses.filter().amountBetween(lowAmount, highAmount, includeLower: false).findAll();
  }

  Future<List<Expense>> getObjectsWithAmountGreaterThan(double amount) async {
    return await isar.expenses.filter().amountGreaterThan(amount).findAll();
  }

  Future<List<Expense>> getObjectsWithAmountLessThan(double amount) async {
    return await isar.expenses.filter().amountLessThan(amount).findAll();
  }

  Future<List<Expense>> getObjectsByOptions(CategoryEnum value, double amountHighValue) async {
    return await isar.expenses.filter().categoryEqualTo(value).or().amountGreaterThan(amountHighValue).findAll();
  }

  Future<List<Expense>> getObjectsNotOthers() async {
    return await isar.expenses.filter().not().categoryEqualTo(CategoryEnum.others).findAll();
  }

  Future<List<Expense>> getObjectsByGroupFilter(String searchText, DateTime dateTime) async {
    return await isar.expenses
        .filter()
        .categoryEqualTo(CategoryEnum.others)
        .group((q) => q.paymentMethodContains(searchText).or().dateEqualTo(dateTime))
        .findAll();
  }

  Future<List<Expense>> getObjectsBySearchText(String searchText) async {
    return await isar.expenses
        .filter()
        .paymentMethodStartsWith(searchText)
        .or()
        .paymentMethodEndsWith(searchText)
        .findAll();
  }

  Future<List<Expense>> getObjectsUsingAnyOf(List<CategoryEnum> categories) async {
    return await isar.expenses
        .filter()
        .anyOf(
          categories,
          (q, CategoryEnum cat) => q.categoryEqualTo(cat),
        )
        .findAll();
  }

  Future<List<Expense>> getObjectsUsingAllOf(List<CategoryEnum> categories) async {
    return await isar.expenses
        .filter()
        .allOf(
          categories,
          (q, CategoryEnum cat) => q.categoryEqualTo(cat),
        )
        .findAll();
  }

  Future<List<Expense>> getObjectsWithoutPaymentMethod() async {
    return await isar.expenses.filter().paymentMethodIsEmpty().findAll();
  }

  Future<List<Expense>> getObjectsWithTags(int tags) async {
    return await isar.expenses.filter().descriptionLengthEqualTo(tags).findAll();
  }

  Future<List<Expense>> getObjectsWithTagName(String tagWord) async {
    return await isar.expenses.filter().descriptionElementEqualTo(tagWord, caseSensitive: false).findAll();
  }

  Future<List<Expense>> getObjectsBySubCategory(String subCategory) async {
    return await isar.expenses.filter().subCategory((q) => q.nameEqualTo(subCategory)).findAll();
  }

  Future<List<Expense>> getObjectsByReceiptName(String receiptName) async {
    return await isar.expenses
        .filter()
        .receipts((q) => q.nameEqualTo(receiptName).or().nameContains(receiptName))
        .findAll();
  }

  Future<List<Expense>> getObjectsAndPaginate(int offset) async {
    return await isar.expenses.where().offset(offset).limit(2).findAll();
  }

  Future<List<Expense>> getObjectsWithDistinctValues() async {
    return await isar.expenses.where().distinctByCategory().findAll();
  }

  Future<List<Expense>> getOnlyFirstObject() async {
    List<Expense> querySelected = [];

    await isar.expenses.where().findFirst().then((value) {
      if (value != null) {
        querySelected.add(value);
      }
    });
    return querySelected;
  }

  Future<List<Expense>> deleteOnlyFirstObject() async {
    await isar.writeTxn(() async {
      await isar.expenses.where().deleteFirst();
    });
    return await isar.expenses.where().findAll();
  }

  Future<int> getTotalObjects() async {
    return await isar.expenses.where().count();
  }

  Future<void> clearData() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  Future<List<String?>> getPaymentProperty() async {
    return await isar.expenses.where().paymentMethodProperty().findAll();
  }

  Future<double> totalExpenses() async {
    return await isar.expenses.where().amountProperty().sum();
  }

  Future<double> totalExpensesByCategory() async {
    return isar.expenses.where().distinctByCategory().amountProperty().sum();
  }

  Future<List<Expense>> fullTextSearch(String searchText) async {
    return await isar.expenses.filter().descriptionElementContains(searchText).findAll();
  }
}
