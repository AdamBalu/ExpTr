import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/common/enums/saving_category.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:uuid/uuid.dart';
import '../../common/utils/firebase_id.dart';
import '../../plans/model/plan.dart';
import '../model/budget.dart';

class BudgetService {
  final _planService = get<PlanService>();
  final _commonService = get<CommonService>();

  final _budgetCollection = FirebaseFirestore.instance.collection('categoryBudgets').withConverter(
        fromFirestore: (snapshot, _) => Budget.fromJson(withId(snapshot.data()!, snapshot.id)),
        toFirestore: (value, _) => withoutId(value.toJson()),
      );

  Stream<List<Budget>> observeGroupBudgets(List<String> budgetIds) {
    if (budgetIds.isNotEmpty) {
      return _budgetCollection.where(FieldPath.documentId, whereIn: budgetIds).snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
    }

    return Stream.value([]);
  }

  Future<List<Budget>> getBudgetsFromList(List<String> budgetIds) async {
    if (budgetIds.isNotEmpty) {
      final querySnapshot =
          await _budgetCollection.where(FieldPath.documentId, whereIn: budgetIds).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    }

    return [];
  }

  Future<bool> deleteBudget(String budgetId, Plan plan) async {
    bool isDeleted = false;
    var docRef = _budgetCollection.doc(budgetId);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      if (data.value != data.usedValue) {
        _commonService.throwToastNotification("Delete related purchases first");
      } else {
        bool isBudgetRemoved = plan.categoryBudgets.remove(budgetId);
        if (isBudgetRemoved) {
          try {
            await docRef.delete();
            await _planService.editPlan(plan.copyWith(categoryBudgets: plan.categoryBudgets));
            await _planService.addBudget(data.usedValue);
          } catch (e) {
            _commonService.throwToastNotification("Could not delete saving");
            isDeleted = true;
          }
        }
      }
    }

    return isDeleted;
  }

  Future<void> createBudget(ItemCategory itemCategory, double value, Plan plan) async {
    final newBudget = Budget(itemCategory, value, value, const Uuid().v4());
    final List<Budget> existingBudgets = await getBudgetsFromList(plan.categoryBudgets);

    final res = existingBudgets.where((budget) => budget.itemCategory == itemCategory).toList();

    if (res.isEmpty) {
      bool isCreated = await _planService.addCategoryBudget(newBudget);
      if (isCreated) {
        await _budgetCollection.doc(newBudget.id).set(newBudget);
      }
    } else {
      _commonService.throwToastNotification("Budget of this category already exists");
    }
  }

  Future<void> updateBudgetValue(Budget budget, {bool updateTotalValue = false}) async {
    await _budgetCollection.doc(budget.id).update({"usedValue": budget.usedValue});

    if (updateTotalValue) {
      await _budgetCollection.doc(budget.id).update({"value": budget.value});
    }
  }

  Future<double> getTotalBudget(Plan plan, {bool isUsedBudget = false}) async {
    double sum = 0;
    for (int i = 0; i < plan.categoryBudgets.length; i++) {
      var docSnapshot = await _budgetCollection.doc(plan.categoryBudgets[i]).get();
      if (isUsedBudget) {
        sum += docSnapshot.data()!.usedValue;
      } else {
        sum += docSnapshot.data()!.value;
      }
    }
    return sum;
  }
}
