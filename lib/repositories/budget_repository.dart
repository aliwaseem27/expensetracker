import 'package:isar/isar.dart';

import '../collections/budget.dart';
import '../main.dart';
import 'adapter.dart';

class BudgetRepository extends Adapter<Budget> {
  @override
  Future<void> createMultipleObjects(List<Budget> collections) async {
    await isar.writeTxn(() async {
      await isar.budgets.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Budget collection) async {
    await isar.writeTxn(() async {
      await isar.budgets.put(collection);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await isar.budgets.deleteAll(ids);
  }

  @override
  Future<void> deleteObject(Budget collection) async {
    await isar.budgets.delete(collection.id);
  }

  @override
  Future<List<Budget>> getAllObjects() async {
    return await isar.budgets.where().findAll();
  }

  @override
  Future<Budget?> getObjectById(int id) async {
    return await isar.budgets.get(id);
  }

  @override
  Future<List<Budget?>> getObjectsById(List<int> ids) async {
    return await isar.budgets.getAll(ids);
  }

  @override
  Future<void> updateObject(Budget collection) async {
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(collection.id);
      if (budget != null) {
        await isar.budgets.put(collection);
      }
    });
  }
}
