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
}
